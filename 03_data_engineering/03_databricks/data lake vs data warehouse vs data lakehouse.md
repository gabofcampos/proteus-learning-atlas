
- **data warehouse:** data management system to consolidate data from multiple sources in an organized highly structured manner. **very inflexible, expensive and locked in to proprietary systems.**
	- **good for:** structured, tubular data
	- **struggles with:** unstructured data or semi unstructured
	typically used for BI, analytics, data visualization, reporting and prepping data for ML.

- **data lake:** flexible repository to store data in it's raw format (**no need to impose a schema**). addresses limitations of warehouse:
	- stores any kind of data (unstructured and semi as well). 
		-  data is ingested without a predefined schema, enabling a **schema-on-read** model where structure is applied only when the data is accessed for analysis. so users are able to apply their own schemas without duplicating or reshaping the underlying data.
	- inexpensive storage
	- raw data can keep its schema without any transformations (*!! could make the data lake a data swamp*)
	- avoid lock in to a proprietary system by decoupling data storage from the engines that process the data

### data lakehouse: best of both worlds
==built on data lake to store **all** types of data, it still provides structure, performance and governance of data warehouses==

merging both into a single system means data teams don't need access to a warehouse and a lake and they always have the most complete up to date data available.


### data intelligence platform: evolution of the data lakehouse
==the integration of the data lakehouse platform with ai automation.==

provides governance and semantic understanding so AI agents can query and act on enterprise data safely, instead of agents being bolted on separately from where the data lives.