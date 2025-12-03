.. _dialog-non-visual-obj:

=========================
Dialog Non visual objects
=========================

.. only:: html

    .. contents::
       :local:

Tool to manage the non visual objects of the project.

.. figure:: img/non-visual-obj-curves.png

  Window to manage the non visual objects.

We can manage curves, patterns, timeseries, controls and rasters.
In all cases, the following buttons are available:

- Duplicate: allows to duplicate a selected object.
- Create: allows to create a new object.
- Delete: allows to delete a selected object.

This window is used to create and configure non-visual objects.
These elements are stored in the model and can be selectively activated depending on the requirements of each simulation.

Curves
=======

Allows to define curves of control, diversion, pump, rating, shape, storage or tidal type.

To create a curve we will have to specify pairs of values until the curve is defined.
Depending on the type of curve, several pairs of values may be necessary.

Patterns
=========

Allows to define temporal patterns that we can assign to certain network objects.

We can create daily, hourly, monthly or weekend patterns.

Timeseries
===========

Allows to define time series of type boundary condition elevation, boundary condition flow, evaporation, inflow hydrograph,
orifice, rainfall and temperature.

 - BC elevation: boundary condition to set a specific water surface elevation.
 - BC flow: boundary condition to set a specific flow.
 - Evaporation: a time series of evaporation rates can be loaded to account for water loss due to this factor during long hydrological simulations.
 - Inflow hydrograph: boundary condition used to define a specific inflow over time using a hydrograph (discharge vs time).
   This allows modeling variable flow entering the domain.
 - Orifice:
 - Rainfall: allows the user to define a hyetograph to be used in the model.
   Each hyetograpgh is associated with specific spatial coordinates and its location can be manually adjusted using the vertex editor,
   by toggling the editing mode in QGIS and dragging the point to the desired location.
    - If only one hyetograph is provided, the entire domain will receive homogeneous rainfall based on that hyetograph.
    - If multiple hyetographs are loaded, rainfall distribution across the domain will be interpolated using Thiessen polygons.
 - Temperature: a time series of temperatue can be loaded. 

Except for the *BC ELEVATION* option, in all other cases the data can be defined either manually (using relative or absolute times) or by importing it from an external file.

To assign any of the previously defined time series to the model, you must specify the location or geometry where the series will be applied.
This can be done through the attribute table by toggling the editing mode and selecting the relevant geometry.
The attribute table displays one row for each geometry or location in the domain.
To assign the appropriate time series to each location, activate the editing mode and use the drop-down menu in the "timeseries" column to choose from the predefined time series.

.. figure:: img/non-visual-obj-assign-hyetograph.png

    Hyetograph attribute table.

Controls
=========

Orders or instructions that determine how the network works over time.

Rasters
========

They integrate spatial data to represent variability of parameters such as precipitation.

These rasters may represent either rainfall volume (mm) or rainfall intensity (mm/h).
The user must specify the type of data contained in the rasters, as well as the corresponding timestamp for each file to ensure correct temporal assignment during the simulation.

.. note:: Rasters can be imported with the import button on the manager.

.. figure:: img/non-visual-obj-rasters.png

  Raster Editor. 

.. important:: The non-visual objects must be assigned to their corresponding locations (geometries) in the model via their respective attribute tables.
  
