.. _what-is-ibergis:

===============
What is IberGIS?
===============

.. only:: html

   .. contents::
      :local:

IberGIS is the first free software designed for the 1D-2D simulation of sewerage networks in QGIS environment.

Designed as a QGIS plugin, one of the main challenges of the project has been to accoplate the SWMM calculation engine (1D simulation) with the Iber calculation engine (2D simulation)
in order to simulate together the sewage and urban drainage networks.

All the necessary data corresponding to SWMM (junction, divider, outfall, storage, inlet, conduit, pump, orifice, weir and outlet) and
to Iber (hyetograph, boundary conditions, roof and ground) are stored in geopackage format (gpkg) in the working scheme created in QGIS.

To work with IberGIS we can create two types of schemes:

- Empty data: empty data schema in which we will import our data.
- Example data: schema that contains a project with example data to practice and become familiar with IberGIS.

