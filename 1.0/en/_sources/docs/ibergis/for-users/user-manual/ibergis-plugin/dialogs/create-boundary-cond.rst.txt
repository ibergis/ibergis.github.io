.. _dialog-create-boundary-cond:

=================================
Dialog Create boundary conditions
=================================

.. only:: html

    .. contents::
       :local:

Tool for setting boundary conditions. By clicking on the button we can click on the corresponding lines to set the boundary conditions.
Then, a form will appear where we must to specify:


.. figure:: img/create-boundary-cond.png

  Window to create a new boundary condition - 2D Inlet.

- ID: identifier of the boundary condition.
- Code: code of the boundary condition.
- Descript: a short description of the boundary condition.
- BC Scenario: boundary condition scenario in which the new boundary condition will be stored.
- Bounday Type: we can select two options:
    
    - *2D Inlet*: we use it to specify an inlet flow. It is necessary to select an option for the inlet (*Total Discharge* or *Water Elevation*) and the inlet condition (*Critical/Subcritical*).
    - *2D Outlet*: we use it to specify an outlet flow. You must select the flow condition, either Subcritical or Supercritical/Critical.
     - If *Subcritical* is selected, you must also define the outlet type (*Weir* or *Given level*) and the crest definition (*Height* or *Elevation*), along with their corresponding values.
     - If *Supercritical/Critical* is selected, no additional parameters are required, it simply allows the generated flow to leave the model domain.
 
- Time Series: this option allows us to specify an inlet hydrograph. **It is only available when we select 2D inlet option**.

.. important:: The boundary conditions are directly applied to a specific existing scenario, the one active while adding them or *current scenario*. If you want to specify the boundary conditions to a certain scenario make sure that it is the one active at the moment. 

Once boundary conditions exist, they can be edited directly by enabling editing through the *Toggle Editing* button, either from the map or the attribute table.