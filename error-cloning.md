## if there is an error of more executed transactions 


# install on all nodes
INSTALL PLUGIN clone SONAME 'mysql_clone.so';


# Install on primary node 
CREATE USER 'kbp_clone_user'@'%' IDENTIFIED BY 'BFuJ4#93SLG';
GRANT BACKUP_ADMIN ON *.* TO 'kbp_clone_user'@'%';
SHOW GRANTS FOR 'kbp_clone_user'@'%';


# Install on broken node 
SET GLOBAL clone_valid_donor_list='donor_ip:3306';
SET GLOBAL clone_valid_donor_list='10.128.0.13:3306';


# On the broken node 

CLONE INSTANCE FROM 'kbp_clone_user'@'donor_ip':3306 IDENTIFIED BY 'BFuJ4#93SLG';
CLONE INSTANCE FROM 'kbp_clone_user'@10.128.0.13:3306 IDENTIFIED BY 'BFuJ4#93SLG';


# Setup up channel

CHANGE REPLICATION SOURCE TO SOURCE_USER='usr_replication', SOURCE_PASSWORD='Pass!12345' FOR CHANNEL 'group_replication_recovery';


# START REPLICATION

START GROUP_REPLICATION