# Danta - AEM Demo Project

Danta is the agnostic multi-platform templating engine. enables developers and IT teams to use technologies they already know, expediting the creation and leveraging of reusable technical assets.

Danta - AEM Demo Project is the maven project contained source codes specifically for demoing Danta capability on AEM.

## Prerequisites

 * Java 8
 * AEM 6.2 or later (for integration with AEM)
 * ACS AEM Commons

## Documentation

### Embedded Dependencies

This project embeds Danta dependencies using `content-package-maven-plugin` plugin, and is actived with `deploy-aem-package` profile. Danta bundles and AEMBase package will be installed under `/apps/dantademo/install` directory. See more about [DantaFramework/AEM](https://github.com/DantaFramework/AEM)

### Installation

  * Via AEM Package Manager, install [ACS AEM Commons 3.17.0](https://github.com/Adobe-Consulting-Services/acs-aem-commons/releases/tag/acs-aem-commons-3.17.0) or later
  * Clone this repository and review or change the Danta version in the pom.xml file

  ```xml
  <properties>
        ...
         <!-- Danta version -->
        <danta.api.version>1.0.2-SNAPSHOT</danta.api.version>
        <danta.core.version>1.0.2-SNAPSHOT</danta.core.version>
        <danta.aem.version>1.0.6-SNAPSHOT</danta.aem.version>
        <danta.aem-base.version>1.0.2-SNAPSHOT</danta.aem-base.version>
    </properties>
  ```
  * Compile and deploy to AEM (See instructions below)

    **Note: for fresh installation, make sure to install ACS Common before running the maven build command**

### Official documentation

  * Read our [official documentation](https://danta.tikaltechnologies.io/docs) for more information.

## License

Read [License](LICENSE) for more licensing information.

## Contribute

Read [here](CONTRIBUTING.md) for more information.

## Compile

    mvn clean install

## Deploy to AEM

Build to author instance

    mvn clean install -Pdeploy-aem-package

Build to publish instance

    mvn clean install -Pdeploy-aem-publish-package

## Maven Build Failure

If maven build failed with error message, similar to below

    Request failed: org.apache.jackrabbit.vault.packaging.PackageException: javax.jcr.nodetype.ConstraintViolationException: OakConstraint0021: /home/users/system/danta/zuskqdMThcLm-W1-QBV4[[rep:SystemUser]]: Mandatory property rep:principalName not found in a new node (500)

This is to "danta-config-service". To fix this:

 * Go to Package Manager (/crx/packmgr/index.jsp)
 * Upload [SystemUser-DantaBase-1.0.0.zip](https://github.com/DantaFramework/AEMBase/blob/master/SystemUser-DantaBase-1.0.0.zip)
 * Install
 * Run maven build command again (re: Deploy to AEM)

 or you can install via command line:

    curl -u admin:admin -F file=@"SystemUser-DantaBase-1.0.0.zip" -F name="SystemUser-DantaBase-1.0.0.zip" \
            -F force=true -F install=true http://localhost:4505/crx/packmgr/service.jsp

 
## Credit

Special thanks to Jose Alvarez, who named Danta for the powerful ancient Mayan pyramid, La Danta. 
La Danta is the largest pyramid in El Mirador—the biggest Mayan city found in Petén, Guatemala.