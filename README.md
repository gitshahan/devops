# devops
Setup your azure function with following instructions.
### Variables
Open azue cli from portal, update values in following lines and run them. These values will be used to provision services required for your function app.
```bash
export location="westus2"  
export rgName="devopsrg"
export aspName="devopsasp"  
export functionName="devops"
```
### Provision Services
Run following commands that will clone this repo, create [resource group](./sub.bicep), [ACR, ASP and Function](./resGrp.bicep) in your azure subscription.
```bash
git clone https://github.com/gitshahan/devops
az deployment sub create --name $rgName --location $location --template-file devops/sub.bicep --parameters rgName=$rgName rgLocation=$location
az deployment group create --resource-group $rgName --template-file devops/resGrp.bicep --parameters aspName=$aspName functionName=$functionName
```
### Init Function Template
Setup azure function python template locally.
```bash
mkdir -p mponafunc/.github/workflows && cd mponafunc
cp ../devops/main.yml .github/workflows && cp ../devops/Dockerfile .
azd init --template functions-quickstart-python-http-azd -e flexquickstart-py
rm -rf .git
```
### GitHub
Create github repo and add secrets for logging in to ACR.
```bash
git config --global user.email “shahan@autonicals.org”
git config --global user.name “gitshahan”
gh auth login
gh repo create mponafunc --private
gh secret set ACR_NAME -b"${acrName}" -R gitshahan/mponafunc
gh secret set ACR_PASS -b"${ACRPASS}" -R gitshahan/mponafunc
gh secret set FUNCTION_APP_NAME -b"${functionName}" -R gitshahan/mponafunc
gh secret set RESOURCE_GROUP -b"${rgName}" -R gitshahan/mponafunc
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/gitshahan/mponafunc.git
git push -u origin main
```
### Summary
Following all these steps will build and upload container image to ACR using github actions.
Next, use this image in function app.
