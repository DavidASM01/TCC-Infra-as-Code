# baixando imagem docker do servidor web wildfly
FROM jboss/wildfly:16.0.0.Final

# variáveis de ambiente padrão para o servidor web wildfly
ENV WF_ADMIN_USER webbudget
ENV WF_ADMIN_PASS webbudget

# variáveis de ambiente padrão para o banco de dados
ENV DB_HOST postgres
ENV DB_PORT 5432
ENV DB_NAME webbudget
ENV DB_USER sa_webbudget
ENV DB_PASS sa_webbudget

# defini o usuário para executar comandos abaixo
USER root

# criando a pasta onde o driver do banco de dados (postgres) será colocado
RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/main

# copiando driver do banco de dados (postgres)
COPY files/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/main
COPY files/postgresql-42.2.5.jar /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/main/

# copiando configurações do servidor web wildfly
COPY files/standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml

# copiando arquivo de implantação(war) do aplicativo para a pasta
COPY files/web-budget-3.0.1-RELEASE.war /opt/jboss/wildfly/standalone/deployments

# adicionando usuário administrador do servidor wildfly 
RUN /opt/jboss/wildfly/bin/add-user.sh ${WF_ADMIN_USER} ${WF_ADMIN_PASS} --silent

# expondo a  porta https para aplicação e gerenciamento do servidor web
EXPOSE 443 9993 80

# iniciando servidor web
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]