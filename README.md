# devops
export location="eastus2"
export rgName="mponaapi"
export acrName="mponaacr"
export acrSKU="Basic"
export aspName="mponaasp"
export functionName="mponaapi"

git clone https://github.com/gitshahan/devops
az deployment sub create --name $rgName --location $location --template-file devops/sub.bicep --parameters rgName=$rgName rgLocation=$location

az deployment group create --resource-group $rgName --template-file devops/resGrp.bicep --parameters acrName=$acrName acrSKU=$acrSKU kvName=$kvName kvSKU=$kvSKU currUser=$currUser
ACRPASS=$(az acr credential show --name $acrName --query "passwords[0].value" -o tsv)

mkdir -p mponafunc/.github/workflows && cd mponafunc
cp ../devops/main.yml .github/workflows && cp ../devops/Dockerfile .
azd init --template functions-quickstart-python-http-azd -e flexquickstart-py
rm -rf .git

git config --global user.email “shahan@autonicals.org”
git config --global user.name “gitshahan”
gh auth login
gh repo create mponafunc --private
gh secret set ACR_NAME -b"${acrName}" -R gitshahan/mponafunc
gh secret set ACR_PASS -b"${ACRPASS}" -R gitshahan/mponafunc
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/gitshahan/mponafunc.git
git push -u origin main

Get login server, username and password from ACR and store them as separate secrets in the keyvault.
Create a folder mponafunc and use azd to create new azure function
Copy Dockerfile and workflow yaml file from devops folder
run git commands to create the repo, add secrets in git repo to login ACR and push all the code.
This will build and upload container image to ACR.
Next use this image in mponafunc.
