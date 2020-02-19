#/bin/bash
#
docker run -itd -p 8290:8290 -p 8253:8253 --name micro-integrator wso2/micro-integrator:1.0.0
#
echo "Run example :- scp file to container -: https://ei.docs.wso2.com/en/latest/micro-integrator/develop/integration-development-kickstart/ "
#
wget https://ei.docs.wso2.com/en/latest/micro-integrator/assets/attach/developing-first-integration/DoctorInfo.jar
java -jar DoctorInfo.jar
#
