.. _dialog-bridge-actions:

=====================
Dialog Bridge Actions
=====================

.. only:: html

    .. contents::
       :local:

Tool to incorporate bridges to the model.

You can create a bridge by drawing it directly over the geometry. Some dimensional characteristics must be defined, such as the elevation.
The bridge length is automatically calculated from the drawn line. You can manually edit the geometry.

.. figure:: img/bridge-actions-definition.png

  Window to set the bridge parameters.

To correctly define the section characteristics, **a valid Digital Elevation Model (DEM) must be loaded** by clicking on *Raster File (DEM)* and choosing the layer with the DEM information.
Otherwise, the riverbed will remain flat.

.. figure:: img/add-DEM-to-bridge.png

  DEM loaded to the bridge.

  .. note:: Make sure that the *Digitize by segment* mode is enabled in the QGIS menu.
    If another mode is selected (for example, *Digitize by shape*) the bridge geometry will follow that drawing style.
    
