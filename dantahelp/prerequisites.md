# Danta Prerequisites - AEM

Danta runs inside an OSGI container, just like the one running behind the scenes of AEM (Apache Felix). In addition of having AEM running , you will need to add the following AEM packages/bundles:

* ACS AEM Commons version 3.x
* Danta API bundle
* Danta Core bundle
* Danta AEM bundle  

## ACS AEM Commons version 3.x

This is an AEM development toolkit for bootstrapping AEM projects with common functionality, developed by Adobe Consulting Services

https://adobe-consulting-services.github.io/acs-aem-commons/

## Danta API Bundle

The API Bundle has the definition for all the interfaces exposed for:

* Configurations
	* Configuration
	* Configuration Provider
	* Mode
* Content Model
* Context Processors
	* Context Processor
	* Context Processor Engine
	* DOMProcessor
	* DOMProcessor Engine
* Execution Context
* Template Content Model

## Danta Core Bundle

The Core Bundle contains the implementation for the common functionality, which is platform agnostic.

This bundle includes the implementation for:

* Context Processors
* Context Processor Engine
* DOM Processor Engine
* Execution Context
  
  
### [Exercise - Install Danta on your AEM instance](prerequisites/install.md)




[Go back to start](danta-aem.md)
