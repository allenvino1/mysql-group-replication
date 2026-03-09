# Generate uuid for the cluster 
uuidgen



# Add in the cnf file 


# Reset root pass on all nodes
 ALTER USER 'root'@'localhost' IDENTIFIED BY 'Test123@';


# Add in the user pass on .my.cnf on root 
`
[client]
user=root
password=Test123@
`

# Create log file loc

sudo mkdir /var/log/mysql
sudo chown mysql:mysql /var/log/mysql



#  Install the group replication plugin.

INSTALL PLUGIN group_replication SONAME 'group_replication.so';
 
-- validate
SHOW PLUGINS;




# sudo setenforce 0 for port restrictoin on 33061




# All Nodes 
CREATE USER usr_replication@'10.128.0.%' IDENTIFIED BY 'Pass!12345';
GRANT REPLICATION SLAVE ON *.* TO usr_replication@'10.128.0.%';
FLUSH PRIVILEGES;

# SEt group replication channel on all nodes
CHANGE REPLICATION SOURCE TO SOURCE_USER='usr_replication', SOURCE_PASSWORD='Pass!12345' FOR CHANNEL 'group_replication_recovery';



# Bootstrap but first node first 


-- checking
select @@group_replication_bootstrap_group;
 
-- setting
SET GLOBAL group_replication_bootstrap_group=ON;


START GROUP_REPLICATION;

SET GLOBAL group_replication_bootstrap_group=OFF;

SELECT * FROM performance_schema.replication_group_members; to check the member 
SELECT MEMBER_ROLE, MEMBER_HOST, MEMBER_STATE FROM performance_schema.replication_group_members;



# Setup the secondary node. Start the replication right away no need to bootstrap since we have a master already

START GROUP_REPLICATION;


# Check if instance is read only 

SELECT @@global.read_only;






