#!/bin/bash

mysql -uroot < ./safe_sql.sql
ret_code=$?
if [ $ret_code != 0 ]; then
  echo "Error when logging in with root using no password"
  echo "The password is already set for the root"
else
  echo "Success when logging in with root using no password"
  echo "We need to set the password for the root"
  mysql -uroot < ./set_root_password.sql
fi

mysql -uroot -pchangeme < ./safe_sql.sql
ret_code=$?
if [ $ret_code != 0 ]; then
  echo "Error when logging in with root using password"
  exit $ret_code
else
  echo "Success when logging in with root using password"
fi

mysql -uroot -pchangeme < ./create_cedar_user.sql
ret_code=$?
if [ $ret_code != 0 ]; then
  echo "Error when creating cedar app user"
  exit $ret_code
else
  echo "Success when creating cedar app user"
fi
