==============================
Table of Contents (ToC)
==============================

.. only:: html

   .. contents::
      :local:

The following layer groups are organized by default in the table of contents (ToC) of an IberGIS project:

TEMPORAL
========

Layers automatically generated during the model validation and correction processes. They are not saved in the GeoPackage.

INPUT
=====

Groups all the model's input data.

- **SWMM:** objects imported from the drainage network's INP file (dwf, inflow, junction, divider, outfall, storage, conduit, pump, orifice, weir and outlet), an their symbology.
- **IBER:** hydraulic elements required for 2D surface calculations, including inlets, pinlets, hyetographs, boundary conditions, bridges, culverts, and inlet connections to the network.
- **MESH:** ground and roof layers, along with mesh anchor lines and mesh anchor points.

BASE MAP
========

Reference map loaded by default in the project.

.. figure:: img/toc.png

      Layers in table of contents.