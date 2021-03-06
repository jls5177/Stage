#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /pg/pgblitz/menu/functions/functions.sh

rolename=$(cat /pg/var/pgcloner.rolename)
roleproper=$(cat /pg/var/pgcloner.roleproper)
projectname=$(cat /pg/var/pgcloner.projectname)
projectversion=$(cat /pg/var/pgcloner.projectversion)
startlink=$(cat /pg/var/pgcloner.startlink)

mkdir -p "/pg/$rolename"

initial () {
  ansible-playbook "/pg/stage/pgcloner/core/primary.yml"
  echo ""
  echo "💬  Pulling Update Files - Please Wait"

  file="/pg/$rolename/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
  bash /pg/${rolename}/${startlink}
}

developer () {
  echo "dev" > /pg/var/pgcloner.projectversion
  ansible-playbook "/pg/stage/pgcloner/core/primary.yml"
  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/pg/$rolename/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
  bash /pg/${rolename}/${startlink}
}

custom () {
  mkdir -p "/pg/$rolename"
  ansible-playbook "/pg/stage/pgcloner/core/personal.yml"

  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/pg/$rolename/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
  bash /pg/${rolename}/${startlink}
}

mainbanner () {
clonerinfo=$(cat /pg/var/pgcloner.info)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 $roleproper | 📓 Reference: $rolename.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$clonerinfo

[1] Utilize $roleproper - Official
[2] Utilize $roleproper - Developer (Beta)
[3] Utilize $roleproper - Personal  (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        initial ;;
    2 )
        initial ;;
    3 )
        variable /pg/var/$rolename.user "NOT-SET"
        variable /pg/var/$rolename.branch "NOT-SET"
        pinterface ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

pinterface () {

user=$(cat /pg/var/$rolename.user)
branch=$(cat /pg/var/$rolename.branch)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 $roleproper | 📓 Reference: $rolename.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 User: $user | Branch: $branch

[1] Change User Name & Branch
[2] Deploy $roleproper - Personal (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 IMPORTANT MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Username & Branch are both case sensitive! Make sure to check for the
default or selected branch!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -p 'Username | Press [ENTER]: ' user < /dev/tty
        read -p 'Branch   | Press [ENTER]: ' branch < /dev/tty
        echo "$user" > /pg/var/$rolename.user
        echo "$branch" > /pg/var/$rolename.branch
        pinterface ;;
    2 )
        existcheck=$(git ls-remote --exit-code -h "https://github.com/$user/$projectname" | grep "$branch")
        if [ "$existcheck" == "" ]; then echo;
        read -p '💬 Exiting! Forked Version Does Not Exist! | Press [ENTER]: ' typed < /dev/tty
        mainbanner; fi
        custom ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

# FUNCTIONS END ##############################################################
echo "" > /pg/tmp/output.info
mainbanner
