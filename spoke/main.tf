resource "azurerm_resource_group" "rg_spoke1" {
 name     = var.rg_spoke1_name
 location = var.location
}

resource "azurerm_resource_group" "rg_spoke2" {
 name     = var.rg_spoke2_name
 location = var.location
}

resource "random_id" "rnd_spoke1" {
    keepers = {
        resource_group = azurerm_resource_group.rg_spoke1.name
    }
    byte_length = 8
}

resource "random_id" "rnd_spoke2" {
    keepers = {
        resource_group = azurerm_resource_group.rg_spoke2.name
    }
    byte_length = 8
}

resource "azurerm_storage_account" "sa_spoke1" {
    name                        = "diag${random_id.rnd_spoke1.hex}"
    resource_group_name         = azurerm_resource_group.rg_spoke1.name
    location                    = azurerm_resource_group.rg_spoke1.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Prod"
    }
}

resource "azurerm_storage_account" "sa_spoke2" {
    name                        = "diag${random_id.rnd_spoke2.hex}"
    resource_group_name         = azurerm_resource_group.rg_spoke2.name
    location                    = azurerm_resource_group.rg_spoke2.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Prod"
    }
}

resource "azurerm_lb" "lb_spoke1" {
 name                = "lb-spoke1"
 location            = azurerm_resource_group.rg_spoke1.location
 resource_group_name = azurerm_resource_group.rg_spoke1.name

 frontend_ip_configuration {
   name                 = "Spoke1-LB-IP"
   subnet_id            = data.azurerm_subnet.sn_spoke1.id
 }
}

resource "azurerm_lb_backend_address_pool" "lbpool_spoke1" {
 resource_group_name = azurerm_resource_group.rg_spoke1.name
 loadbalancer_id     = azurerm_lb.lb_spoke1.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbprobe_spoke1" {
 resource_group_name = azurerm_resource_group.rg_spoke1.name
 loadbalancer_id     = azurerm_lb.lb_spoke1.id
 name                = "HTTP"
 port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule_spoke1" {
   resource_group_name            = azurerm_resource_group.rg_spoke1.name
   loadbalancer_id                = azurerm_lb.lb_spoke1.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.lbpool_spoke1.id
   frontend_ip_configuration_name = "Spoke1-LB-IP"
   probe_id                       = azurerm_lb_probe.lbprobe_spoke1.id
}

resource "azurerm_lb" "lb_spoke2" {
 name                = "lb-spoke2"
 location            = azurerm_resource_group.rg_spoke2.location
 resource_group_name = azurerm_resource_group.rg_spoke2.name

 frontend_ip_configuration {
   name                 = "Spoke1-LB-IP"
   subnet_id            = data.azurerm_subnet.sn_spoke2.id
 }
}

resource "azurerm_lb_backend_address_pool" "lbpool_spoke2" {
 resource_group_name = azurerm_resource_group.rg_spoke2.name
 loadbalancer_id     = azurerm_lb.lb_spoke2.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbprobe_spoke2" {
 resource_group_name = azurerm_resource_group.rg_spoke2.name
 loadbalancer_id     = azurerm_lb.lb_spoke2.id
 name                = "HTTP"
 port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule_spoke2" {
   resource_group_name            = azurerm_resource_group.rg_spoke2.name
   loadbalancer_id                = azurerm_lb.lb_spoke2.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.lbpool_spoke2.id
   frontend_ip_configuration_name = "Spoke1-LB-IP"
   probe_id                       = azurerm_lb_probe.lbprobe_spoke2.id
}

resource "azurerm_virtual_machine_scale_set" "vmss_spoke1" {
 name                = "vmss-spoke1"
 location            = azurerm_resource_group.rg_spoke1.location
 resource_group_name = azurerm_resource_group.rg_spoke1.name
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_B1s"
   tier     = "Standard"
   capacity = 1
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vm-spoke1"
   admin_username       = var.admin_user
   admin_password       = var.admin_password
   custom_data          = file("web.conf")
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = data.azurerm_subnet.sn_spoke1.id
     load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lbpool_spoke1.id]
     primary = true
   }
 }

 boot_diagnostics {
     enabled = true
     storage_uri = azurerm_storage_account.sa_spoke1.primary_blob_endpoint
 }
}

resource "azurerm_virtual_machine_scale_set" "vmss_spoke2" {
 name                = "vmss-spoke2"
 location            = azurerm_resource_group.rg_spoke2.location
 resource_group_name = azurerm_resource_group.rg_spoke2.name
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_B1s"
   tier     = "Standard"
   capacity = 1
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vm-spoke2"
   admin_username       = var.admin_user
   admin_password       = var.admin_password
   custom_data          = file("web.conf")
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = data.azurerm_subnet.sn_spoke2.id
     load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lbpool_spoke2.id]
     primary = true
   }
 }

 boot_diagnostics {
     enabled = true
     storage_uri = azurerm_storage_account.sa_spoke2.primary_blob_endpoint
 }
}
