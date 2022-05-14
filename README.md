# Enterprise Scale Analytics Scenario
## Management Zone


### Needs: 
- Support for Azure VNet Data Gateway:  this will likely need to leverage azapi module, given it is in preview
- Support for Azure Policy.  
- More coherent IAM implementation
- Add support for IaaS CICD agents 
- CICD implementation example & documentation
- **Standards review & QC**



### Deviations from official guidance:

Implements ADF Self-Hosted Integration Runtime as a shared IaaS service at the Management Zone layer so that they can be shared and more efficiently utilized by workloads spanning multiple landing zones.  This does not preclude customer from also implementing these separately, at the landing zone layer, per their requirements.

Private DNS Zones are assumed to already be located in an existing subscription, likely Platform Connectivity.  However, it's structured so that they are setup as a 'remote object', which will enable us to create a separate input for zones which should be created within the management zone.

The implementation may blend guidance from original 2021 scenario release with the update from 04/22.  