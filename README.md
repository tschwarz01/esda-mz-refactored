# Azure Cloud Adoption Framework: 
## Cloud Scale Analytics Scenario


### Management Zone

### Requires:
- 'resources' helper module

from project root:  

`git clone https://github.com/tschwarz01/terraform-custom-caf-module.git resources`

### Needs: 
- Support for Azure Policy.  
- More coherent IAM implementation
- Add support for IaaS CICD agents 
- CICD implementation example & documentation
- **Standards review & QC**



### Deviations from official guidance:

Implements ADF Self-Hosted Integration Runtime as a shared IaaS service at the Management Zone layer so that they can be shared and more efficiently utilized by workloads spanning multiple landing zones.  This does not preclude customer from also implementing these separately, at the landing zone layer, per their requirements.

Private DNS Zones are assumed to already be located in an existing subscription, likely Platform Connectivity.  However, it's structured so that they are setup as a 'remote object' input, which will enable us to create a separate input for zones which should be created within the management zone.  

The implementation may blend guidance from original 2021 scenario release with the update from 04/22.  