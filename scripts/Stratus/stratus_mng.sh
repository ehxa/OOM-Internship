echo "Welcome to openStack Stratus!"
echo "This script will help you manage your Stratus cluster."
echo ""
read -p "Please enter your project folder: " project
cd $project
ls
echo ""
read -p "Please enter the name of your OpenStack credentials file: " credentials
source $credentials
echo ""
read -p "Please enter the name of Python virtual environment to use: " venv
source $venv/bin/activate
echo ""
echo "OpenStack Stratus is ready to use."
echo ""

function create_instance {
    echo ""
    openStack server list
    echo "Please enter the following information to create an instance:"
    read -p "Enter the name of the instance: " name
    openStack image list
    read -p "Enter the image name: " image
    openstack flavor list
    read -p "Enter the flavor: " flavor
    openStack network list
    read -p "Enter the network: " network
    openstack server create --flavor $flavor --image $image --nic net-id=$network $name
}

function delete_instance {
    echo ""
    openStack server list
    read -p "Enter the name of the instance: " name
    openstack server delete $name
}

function create_volume {
    echo ""
    openstack volume list
    read -p "Enter the name of the volume: " name
    read -p "Enter the size of the volume: " size
    openstack volume create --size $size $name
}

function delete_volume {
    echo ""
    openstack volume list
    read -p "Enter the name of the volume: " name
    openstack volume delete $name
}


function attach_volume {
    echo ""
    openStack volume list
    read -p "Enter the name of the volume: " volume
    openStack server list
    read -p "Enter the name of the instance: " instance
    openstack server add volume $instance $volume
}

function detach_volume {
    echo ""
    openStack volume list
    read -p "Enter the name of the volume: " volume
    openStack server list
    read -p "Enter the name of the instance: " instance
    openstack server remove volume $instance $volume
}

function list_instances {
    echo ""
    openstack server list
}

function shelve_instance {
    echo ""
    openStack server list
    read -p "Enter the name of the instance: " instance
    openstack server shelve $instance
}

function unshelve_instance {
    echo ""
    openStack server list
    read -p "Enter the name of the instance: " instance
    openstack server unshelve $instance
}

function list_flavors {
    echo ""
    openstack flavor list
}

function list_images {
    echo ""
    openstack image list
}


function list_volumes {
    echo ""
    openstack volume list
}

function list_attached_volumes {
    echo ""
    read -p "Enter the name of the instance: " instance
    openstack server show $instance
}

function mainOptions {
    echo ""
    echo "Please select an option:"
    echo "1. Instances"
    echo "2. Volumes"   
    echo "0. Exit"
}

function instanceOptions {
    echo ""
    echo "Please select an option:"
    echo "1. Create instance"
    echo "2. Delete instance"
    echo "3. Shelve instance"
    echo "4. Unshelve instance"
    echo "5. List instances"
    echo "6. List flavors"
    echo "7. List images"
    echo "0. Back"
}

function volumeOptions {
    echo ""
    echo "Please select an option:"
    echo "1. Create volume"
    echo "2. Delete volume"
    echo "3. Attach volume"
    echo "4. Detach volume"
    echo "5. List volumes"
    echo "6. List attached volumes"
    echo "0. Back"
}

mainOptions
read -p "Option:" option
while [ $option -ne 0 ]
do
    case $option in
        1)
            instanceOptions
            read -p "Option:" instance_option
            while [ $instance_option -ne 0 ]
            do
                case $instance_option in
                    1)
                        create_instance
                        ;;
                    2)
                        delete_instance
                        ;;
                    3)
                        shelve_instance
                        ;;
                    4)
                        unshelve_instance
                        ;;
                    5)
                        list_instances
                        ;;
                    6)
                        list_flavors
                        ;;
                    7)
                        list_images
                        ;;
                    *)
                        echo "Invalid option."
                        ;;
                esac
                instanceOptions
                read -p "Option:" instance_option
            done
            ;;
        2)
            volumeOptions
            read -p "Option:" volume_option
            while [ $volume_option -ne 0 ]
            do
                case $volume_option in
                    1)
                        create_volume
                        ;;
                    2)
                        delete_volume
                        ;;
                    3)
                        attach_volume
                        ;;
                    4)
                        detach_volume
                        ;;
                    5)
                        list_volumes
                        ;;
                    6)
                        list_attached_volumes
                        ;;
                    *)
                        echo "Invalid option."
                        ;;
                esac
                volumeOptions
                read -p "Option:" volume_option
            done
            ;;
        *)
            echo "Invalid option."
            echo ""
            ;;
    esac
    mainOptions
    read -p "Option:" option
done
echo ""
echo "Exiting Stratus management script."