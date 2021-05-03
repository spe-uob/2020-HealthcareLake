# Healthcare Data Lake - Portfolio B

## Overview

## Stakeholder and Requirements

### Stakeholders

Philip Harfield is our client and primary stakeholder, and this software is being developed for him at Bristol, North Somerset and South Gloucestershire NHS CCG
(BNSSG). 

- The primary user story for this stakeholder is that BNSSG may require information about long-term data analytics from multiple sources. E.g how the long term health of patients has been affected by particular surgeries in childhood. This information could then be used to inform understanding of the merits of
previous clinical decisions taken.
- Additionally, another user story is it may require information in a more short term basis about the healthcare of the local population. E.g  to determine what percentage of people registered with a GP have been admitted to hospital in a given year. This information could then be used to inform strategic commissioning decisions on local healthcare services.
- Also BNSSG may want to use the software to curate datamarts from the data which can then be queried by external clients while maintaining security of the data lake. E.g A datamart could be curated of non-identifiable patient data of people who have had particular condition, so external research can be carried out on this condition without breaching data regulations. 

Now considering the user stories above, we can breakdown the story into a sequence of steps of user flow:

1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes.
2. BNSSG use their secure access credentials to gain access to the lake.
3. BNSSG use a data analytics environment of their choice to query the lake based on records where the patient has had a particular surgery.
4. Clinical or strategical commissioning decisions can be taken based on the data.

Alternatively, the following user flow could take place for this stakeholder:

1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes. 
2. BNSSG use their secure access credentials to gain access to the lake.
3. BNSSG queries an already created data mart containing only data which is a appropriate to its research. 
4. BNSSG analyses this data using an analytics environment of their choice.
5. Clinical or strategical commissioning decisions can be taken based on the data.

Exceptionally, the following user flow could take place:
 
1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes.
2. BNSSG data analysts provide secure access credentials
3. The analysts receive a message that these user credentials are not valid. 
4. Access to the data is not granted.






## Personal Data, Privacy, Security and Ethics Management

## Architecture

## Development Testing

## Release Testing

## OO Design & UML

## Acceptance Testing (Evaluation)

## Reflection
