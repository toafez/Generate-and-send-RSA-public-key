#!/bin/bash
# Filename: generate-and-send-rsa-public-key.sh
# Script version 1.00 dated 23.11.2025

#           Generate and send RSA public key
#    Copyright (C) 2025 by tommes (toafez) | MIT License

#
# Call: . ./generate-and-send-rsa-public-key.sh "REMOTE-USERNAME" "REMOTE-ADDRESS" "REMOTE-HOSTNAME" "REMOTE-PORT" "KEYFILE-NAME"
#
# REMOTE-USERNAME       : This must be replaced with the username
#                         that you use to log in to the remote system.
#
# REMOTE-ADDRESS        : This must be replaced by the IP address or URL
#                         through which the remote system can be accessed.
#
# REMOTE-HOSTNAME       : This can be replaced with the hostname or designation
#                         of the remote system, such as 'Fileserver' or 'Backupserver', etc.
#                         If no hostname is specified, meaning that no value is enclosed in quotation marks,
#                         no entry will be made in the configuration file ~/.ssh/config
#
# REMOTE-PORT           : This can be replaced by the port through which the remote system can be accessed.
#                         If no port is specified, meaning that no value is enclosed in quotation marks,
#                         the default port "22" is used.
#
# KEYFILE-NAME          : This can be replaced with the name of the file to be used for the RSA key pair.
#                         If no file name is specified, meaning that no value is enclosed in quotation marks,
#                         the default file name "id_rsa" is used.
#
# Let's get started

if [ -d "${HOME}" ]; then

    # Set environment variables
    # -----------------------------------------------------------------------------
    local_username=$(whoami)
    local_hostname=$(hostname)
    remote_username="${1}"
    remote_address="${2}"
    remote_hostname="${3}"
    remote_port="${4}"
    [ -z "${remote_port}" ] && remote_port="22"
    keyfile_name="${5}"
    [ -z "${keyfile_name}" ] && keyfile_name="id_rsa"

    # Display the permissions for the home directory and the user home directory ~/
    # -----------------------------------------------------------------------------
    home_octal=$(stat -c "%a" ~/)
    home_symbolic=$(stat -c "%A" ~/)
    userhome_octal=$(stat -c "%a" "${HOME}")
    userhome_symbolic=$(stat -c "%A" "${HOME}")

    echo
    echo "Display the permissions for the home directory and the user home directory"
    echo " - The permissions for the home directory [ ${HOME%/*} ] are set to ${home_octal} (${home_symbolic})"
    echo " - The permissions for the user home directory [ ${HOME} ] are set to ${userhome_octal} (${userhome_symbolic})"
    echo

    # Create hidden SSH folder in user home folder
    # -----------------------------------------------------------------------------
    echo "Create a new SSH directory structure or check an existing one in the user's local home directory [ $HOME ]."

    # Create the .ssh directory if it doesn't already exist.
    if [ ! -d ~/.ssh ]; then
        mkdir -p ~/.ssh
        if [ -d ~/.ssh ]; then
            echo " - Create the subdirectory [ /.ssh ] in your local home directory [ ${HOME} ]."
        else
            echo " - Failed to create the subdirectory [ ${HOME}/.ssh ]"
            exit 1
        fi
    else
        echo " - The subdirectory [ ${HOME}/.ssh ] already exists."
    fi

    # Set the permissions for the .ssh directory if they are not correct.
    if [[ $(stat -c "%a" ~/.ssh) != "700" ]]; then
        chmod 700 ~/.ssh
        echo " - The permissions for the subdirectory [ ${HOME}/.ssh ] have been changed to 0700 (rwx------)."
    else
        echo " - The permissions for the subdirectory [ ${HOME}/.ssh ] have been checked and are correct."
    fi
    echo

    # Create RSA key file pairs in the ~/.ssh folder
    # -----------------------------------------------------------------------------
    echo "Create new RSA key pairs or check existing ones in the local [ ${HOME}/.ssh ] subdirectory."

    # Create the RSA key file pairs if it doesn't already exist.
    if [ ! -f ~/.ssh/${keyfile_name} ] && [ ! -f ~/.ssh/${keyfile_name}.pub ]; then
        ssh-keygen -b 4096 -t rsa -C "${local_username}@${local_hostname}" -f ~/.ssh/${keyfile_name} -q -P ""
        if [ -f ~/.ssh/${keyfile_name} ] && [ -f ~/.ssh/${keyfile_name}.pub ]; then
            echo " - The private RSA key, named [ ${keyfile_name} ], has been created."
            echo " - The public RSA key, named [ ${keyfile_name}.pub ], has been created."
        else
            echo " - The RSA key pairs, named [ ${keyfile_name} ] and [ ${keyfile_name}.pub ], could not be created!"
            exit 2
        fi
    else
        echo " - The RSA key pairs, named [ ${keyfile_name} ] and [ ${keyfile_name}.pub ], have already been created."
    fi

    # Set the permissions for the private RSA key if they are not correct.
    if [[ $(stat -c "%a" ~/.ssh/${keyfile_name}) != "600" ]]; then
        chmod 600 ~/.ssh/${keyfile_name}
        echo " - The permissions for the private RSA key [ ${keyfile_name} ] have been changed to 0600 (rw-------)."
    else
        echo " - The permissions for the private RSA key [ ${keyfile_name} ] has been verified and is correct."
    fi

    # Set the permissions for the public RSA key if they are not correct.
    if [[ $(stat -c "%a" ~/.ssh/${keyfile_name}.pub) != "600" ]]; then
        chmod 600 ~/.ssh/${keyfile_name}.pub
        echo " - The permissions for the public RSA key [ ${keyfile_name}.pub ] have been changed to 0600 (rw-------)."
    else
        echo " - The public RSA key permissions [ ${keyfile_name}.pub ] have been verified and is correct." 
    fi
    echo

    # Create a file called authorized_keys in the folder '~/.ssh'
    # -----------------------------------------------------------------------------
    echo "Create a new file or check an existing file named [ authorized_keys ] in the local [ ${HOME}/.ssh ] subdirectory."

    # Create the authorized_keys file
    if [ ! -f ~/.ssh/authorized_keys ]; then
        touch ~/.ssh/authorized_keys
        if [ -f ~/.ssh/authorized_keys ]; then
            echo " - The [ authorized_keys ] file has been created."
        else
            echo " - Failed to create [ authorized_keys ] file!"
            exit 3
        fi
    else
        echo " - The [ authorized_keys ] file already exists."
    fi
    echo

    # Add your own public key to authorized_keys file
    # -----------------------------------------------------------------------------
    echo "Add your own public RSA key [ ${keyfile_name}.pub ] to the local [ authorized_keys ] file."

    # Add the public key to the authorized_keys file 
    if [ -f ~/.ssh/authorized_keys ]; then
        public_key=$(cat ~/.ssh/${keyfile_name}.pub)
        if ! grep -qw "${public_key}" ~/.ssh/authorized_keys; then
            echo " - Your public RSA key has been added to the [ authorized_keys ] file."
            cat ~/.ssh/${keyfile_name}.pub >> ~/.ssh/authorized_keys
        else
            echo " - Your public RSA key has already been added to the [ authorized_keys ] file."
        fi
    fi

    # Set the permissions for the authorized_keys file if they are not correct.
    if [[ $(stat -c "%a" ~/.ssh/authorized_keys) != "600" ]] ; then
        chmod 600 ~/.ssh/authorized_keys
        echo " - The permissions for the [ authorized_keys ] file have been changed to 0600 (rw-------)."
    else
        echo " - The permissions for the [ authorized_keys ] file have been verified and are correct."
    fi
    echo

    # Create a file called config in the folder '~/.ssh'
    # -----------------------------------------------------------------------------
    echo "Create a new file or check an existing file named [ config ] in the local [ ${HOME}/.ssh ] subdirectory."

    # Create the authorized_keys file
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config
        if [ -f ~/.ssh/config ]; then
            echo " - The [ config ] file has been created."
        else
            echo " - Failed to create [ config ] file!"
            exit 3
        fi
    else
        echo " - The [ config ] file already exists."
    fi

    # Function to write a data record to the config file.
    function config_entry ()
    {
        echo "Host ${1}" >> ~/.ssh/config
        echo " User ${2}" >> ~/.ssh/config
        echo " Hostname ${3}" >> ~/.ssh/config
        echo " Port ${4}" >> ~/.ssh/config
        echo " PreferredAuthentications publickey" >> ~/.ssh/config
        echo " IdentityFile \"~/.ssh/${5}\"" >> ~/.ssh/config
        echo "" >> ~/.ssh/config
    }

    # Add the data record to the config file
    if [ -n "${remote_hostname}" ]; then
        if ! grep -qw "${remote_hostname}" ~/.ssh/config; then
            echo " - Your remote system [ ${remote_hostname} ] has been added to the [ config ] file."
            config_entry "${remote_hostname}" "${remote_username}" "${remote_address}" "${remote_port}" "${keyfile_name}"
        else
            echo " - Your remote system[ ${remote_hostname} ] has already been added to the [ config ] file."
        fi
    fi

     # Set the permissions for the config file if they are not correct.
    if [[ $(stat -c "%a" ~/.ssh/config) != "600" ]] ; then
        chmod 600 ~/.ssh/config
        echo " - The permissions for the [ config ] file have been changed to 0600 (rw-------)."
    else
        echo " - The permissions for the [ config ] file have been verified and are correct."
    fi
    echo

    # Transfer the public key to the remote system connection
    # -----------------------------------------------------------------------------
    echo "Connect to the remote system [ ${remote_address} ] on port [ ${remote_port} ] to transfer the local public key to it."
    echo " - Note: When establishing an SSH connection to a remote system for the first time, you must confirm the connection by entering 'yes'."
    echo " - Please enter the password for the user [ ${remote_username} ] below to log in to the remote system..."
    echo

    if [ -n "${remote_username}" ] && [ -n "${remote_address}" ] && [ -n "${remote_port}" ]; then
        if [ -x "$(which ssh-copy-id)" ]; then
            ssh-copy-id -i ~/.ssh/${keyfile_name}.pub -p ${remote_port} ${remote_username}@${remote_address}
        else
            cat ~/.ssh/${keyfile_name}.pub | ssh -p ${remote_port} ${remote_username}@${remote_address} \
            "if [ -f ~/.ssh/authorized_keys ]; then \
                if ! grep -qw \"${public_key}\" ~/.ssh/authorized_keys; then \
                    cat >> ~/.ssh/authorized_keys; \
                    if grep -qw \"${public_key}\" ~/.ssh/authorized_keys; then \
                        echo 'success: added the local public key to the remote authorized_keys file'; \
                        chmod -v 600 ~/.ssh/authorized_keys; \
                    else \
                        echo 'error: the local public key could not be entered into the remote authorized_keys file'; \
                    fi \
                else \
                    echo 'info: the local public key has already been stored on the remote authorized_keys file'; \
                fi \
            else \
                [ ! -d ~/.ssh ] && mkdir -v -p ~/.ssh; \
                [ -d ~/.ssh ] && chmod 700 -v ~/.ssh; \
                [ ! -f ~/.ssh/authorized_keys ] && touch ~/.ssh/authorized_keys; \
                cat >> ~/.ssh/authorized_keys; \
                echo 'success: added the local public key to the remote authorized_keys file'; \
                [ -f ~/.ssh/authorized_keys ] && chmod -v 600 ~/.ssh/authorized_keys; \
            fi"
        fi
    else
        echo " - Additional information is required in order to establish the SSH connection."
        exit 5
    fi
    echo
    echo "All operations completed. Disconnect!"
else
    echo "The home folder for user ${local_username} could not be determined!"
fi
