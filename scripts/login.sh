export COOKIE_FILE=.cookie.tmp
rm -rf $COOKIE_FILE
touch $COOKIE_FILE

export PASSWORD=$(cat grafana.pass)

echo $PASSWORD

curl -kis -c $COOKIE_FILE -b $COOKIE_FILE -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "user": "admin",
    "password": "'"$PASSWORD"'"
  }' \
  http://localhost:8080/login

curl -kis -c $COOKIE_FILE -b $COOKIE_FILE \
  http://localhost:8080/

# curl -kiv -c $COOKIE_FILE -b $COOKIE_FILE \
#   -H "Content-Type: application/json" \
#   -H "Accept: application/json" \
#   -H "Authorization: Bearer JQsfck0vG3Z32IXcdMOcwytn23AZBovEp0hfhrah" \
#   http://localhost:8080/api/datasources/name/test_datasource


# export LOGIN_RESPONSE=$(curl -kis -c $COOKIE_FILE -b $COOKIE_FILE -X POST \
#   -H "Content-Type: application/json" \
#   -H "Accept: application/json" \
#   -d '{
#     "user": "admin",
#     "password": "'"$PASSWORD"'"
#   }' \
#   https://localhost:8080/login)

# echo "$LOGIN_RESPONSE"

# export DATASOURCE_RESPONSE=$(curl -kis -c $COOKIE_FILE -b $COOKIE_FILE -X GET \
#   -H "Content-Type: application/json" \
#   -H "Accept: application/json" \
#   -H "Authorization: Bearer JQsfck0vG3Z32IXcdMOcwytn23AZBovEp0hfhrah" \
#   http://localhost:8080/api/datasources/name/test_datasource)

# echo "$DATASOURCE_RESPONSE"