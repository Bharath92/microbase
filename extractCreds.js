function getValuesFromIntegrationJson(formJSONValues) {
  var result = {};
  formJSONValues.forEach(
    function (jsonValue) {
      if(jsonValue.name)
        result[jsonValue.name] = jsonValue.value;
    }
  );

  return result;
}

var jsonValues = getValuesFromIntegrationJson(JSON.parse(process.argv[2]));
console.log('docker login  -u "' + jsonValues.username + '" -p "' + jsonValues.password + '"');
