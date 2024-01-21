#!/bin/bash
set -e

#
# This script is used to update the data.json file from the Curiosa API
# We can't use the API directly from the client because of CORS
#

wget -q https://curiosa.io/api/trpc/card.getAllFaqs -O public/data.json
fileSize=$(stat -c%s "public/data.json")

if [ "$fileSize" -gt 0 ]
then
  echo "Data updated, size: $fileSize"
else
  echo "Data not updated"
fi