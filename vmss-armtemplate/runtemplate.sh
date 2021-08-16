az group create --name azure12312451243_7fb2815088fbc4b5735a49d7_00002 --location "East Asia"
az deployment group create \
  --name Deployment_site1e_GW1 \
  --resource-group azure12312451243_7fb2815088fbc4b5735a49d7_00002 \
  --template-file template.json \
  --parameters @parameters.json
