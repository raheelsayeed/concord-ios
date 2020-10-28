# Release Notes

### v0.1 Build 37

- Demonstration of fetching FHIR based Health Records from iOS Health App
- Can fetch multiple data types: including Conditions, Observations, Medications, immunizations, Lab Tests
- Imports only the __Laboratory tests (FHIR Observation resourceType)__
- All data is in memory and Not saved on device within the app. Relaunches need to go through the authorization again.

### FHIR issues dealt with so far:

- Not all `FHIR Observation` resources have a `code` element. Thus need to handle identifiers
- `Observation`->`valueString` should not be presumed `Integer`. 
