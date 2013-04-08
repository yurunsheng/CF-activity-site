By Yu,Runsheng @2013-4-8
This is a simple note on "activity" project.

This project is based on SpringMVC 3.0, employing MongoDB as the data store. HTML5 & Bootstrap & JQuery & Javascript are combined for the front end.

Some configuration parameters are set in "resources/config.properties", including the root user's identification. Feel free to modify them but keep in mind only the root user has the authority to create and delete users.

When pushing to cloudfoundry.com, mongodb service is supposed to be bound. The service name should be exactly the same as configured by cloud profile in "webapp/WEB-INF/spring/root-context.xml".

The project functions fine when running locally, while when running on Cloud Foundry a timezone-related issue would occur. Since the cloud server adopts UTC time which is different from the developing environment, a transformation between different time standards is expected.  
