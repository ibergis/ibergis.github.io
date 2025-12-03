.. _dialog-go2iber-options:

======================
Dialog Go2Iber options
======================

.. only:: html

    .. contents::
       :local:

Tool to manage all the options involved in the simulation. We can manage the SWMM and Iber options.

Tab IBERGIS OPTIONS
===================

.. figure:: img/ibergis-options.png

    IBERGIS options.

- Project name: name of the current project.
- Description: a short description of the project.
- User: name of the user or project author.
- Creation date: creation date of the project.
- Version: IberGIS version.

Tab SWMM OPTIONS
================

.. figure:: img/swmm-options.png

    SWMM options.

The following options are available:

- Skip steady state: allows to omit the steady phase at the beginning of the hydraulic simulation. The default is NO.
- Allow ponding: determines whether excess water is allowed to collect atop nodes and be re-introduced into the system as conditions permit.
  The default is YES. In order form ponding to actually occur at a particular node, **a non-zero value for its ponded area attribute must be used** (field *apond* on Junction layer).
- Min slope: minimum value allowed for a conduit's slope (%). If zero (the default) then no minimum is imposed (although SWMM uses a lower limit on elevation drop of 0.00035 m when computing a conduit slope).
- Flow units: allow choice the flow units. The default is CMS.
- Flow routing: allow choice which method is used to route flows through the drainage system. The default is DYNWAVE.
- Link offsets: determines the convention used to specify the position of a link offset above the invert of its connecting node.
  DEPTH indicates that offsets are expressed as the distance between the node invert and the link, while ELEVATION indicates that the absolute elevation of the offset is used. The default is ELEVATION.
- Ignore groundwater: allow choice if groundwater calculations should be ignored when a project file contains aquifer objects. The default is NO.
- Ignore rainfall: allow choice if all rainfall data and runoff calculations should be ignored. If is set to YES, SWMM only performs flow and pollutant routing based on user-supplied direct and dry weather inflows.
  The default is NO.
- Ignore routing: allow choice if only runoff should be computed even if the project contains drainage system links and nodes. The default is NO.
- Ignore snowmelt:allow choice if snowmelt calculations should be ignored when a project file contains snow pack objects. The default is NO.
- Ignore quality: allos choice if pollutant washoff, routing and treatment should be ignored in a project that has pollutants defined. The default is NO.
- Force main equation: establishes wheter the Hazen-Williams (H-W) or the Darcy-Wesbach (D-W) equation will be used to compute friction losses for pressurized flow in conduits that have been assigned
  a circular force main cross-section shape. The default is H-W.
- Inertial damping: indicates how the inertial terms in the Saint Venant momentum equation will be handled under dynamic wave flow routing.
  Choosing NONE (the default) maintains these terms at their full value under all conditions. Selecting PARTIAL will reduce the terms as flow comes closer to being critical (and ignores them when flow is supercritical).
  Choosing FULL will drop the terms altogether.
- Lat flow tol: maximum percent difference between the current and previous lateral inflow at all nodes in the conveyance system in order for the *Skip steady state* option to take effect. The default is 5 percent.
- Lengthening step: time step, in seconds, used to lengthen conduits under dynamic wave routing, so that they meet the Courant stability criterion under full-flow conditions
  (i.e., the travel time of a wave will not be smaller than the specified conduit lengthening time step). As this value is decreased, fewer conduits will require lengthening.
  A value of 0 means that no conduits will be lengthened. The default is 1.
- Wet step: time step length used to compute runoff from subcatchments during periods of rainfall or when ponded water still remains on the surface. The default is 00:05:00.
- Sweep start: day of the year (month/day) when street sweeping operations begin. The default is 01/01.
- Sweep end: day of the year (month/day) when street sweeping operations end. The default is 12/31.
- Variable step: safety factor applied to a variable time step computed for each time period under dynamic wave flow routing. The variable time step is computed so as to satisfy the Courant
  stability criterion for each conduit and yet not exceed the *Routing step* value. If the safety factor is 0, then no variable time step is used. The default is 0.75.
- Normal flow limited: specifies which condition is checked to determine if flow in a conduit is supercritical and should thus be limited to the normal flow.
  Use SLOPE to check if the water surface slope is greater than the conduit slope, FROUDE to check if the Froude number is greater than 1 or BOTH to check both conditions. The default is BOTH.
- Min surfarea: minimum surface area used at nodes when computing changes in water depth under dynamic wave routing. If 0 is entered, then the default value of 1.167 m² is used (i.e., the area of a 1,2192 m diameter manhole).
- Dry days: number of days with no rainfall prior to the start of the simulation. The default is 10.
- Dry step: time step length used for runoff computations (consisting essentially of pollutant buildup) during periods when there is no rainfall and no ponded water. The default is 1:00:00.
- Head tolerance: difference in computed head at each node between successive trials below which the flow solution for the current time step is assumed to have converged. The default tolerance is 0.
- Max trials: maximum number of trials allowed during a time step to reach convergence when updating hydraulic heads at the conveyance system's nodes. The default value is 0.
- Sys flow tol: maximum percet difference between total system inflow and total system outflow which can occur in order for the *Skip steady state* option to take effect. The default is 5 percent.
- Threads: number of parallel computing threads to use for dynamic wave flow routing on machines equipped with multi-core processors. The default is 1.
- Minimun step: the smallest time step allowed when variable time steps are used for dynamic wave flow routing. The default is 0.5.
- Routing step: time step length in seconds used for routing flows and water quality constituents through the conveyance system. This can be increased if dynamic wave routing is not used.
  The default is 00:00:02.
- Start date: the date when the simulation begins. If not supplied, a date of 01/01/2017 is used.
- Report start date: the date when reporting of results is to begin. The default is the simulations start date.
- End date: the date when the simulation is to end. The default is the start date.
- Report step: time interval for reporting of computed results. The default is 00:05:00.
- Start time: time of day on the starting date when the simulation begins. The default is 00:00:00.
- End time: time of day on the ending date when the simulation will end. The default is 03:00:00.
- Report start time: time of day on the report starting date when reporting is to begin. The default is the simulation start time of day.

Tab SWMM RESULTS
================

.. figure:: img/swmm-results.png

   SWMM results.

The following options are available:

- Continuity: specifies if continuity checks should be reported or not. The default is YES.
- Flowstats: specifies whether summary flow statistics should be reported or not. The default is YES.
- Controls: specifies whether all control actions taken during a simulation should be listed or not. The default is YES.
- Input: specifies whether or not a summary of the input data should be provided in the output report. The default is NO.
- Timestep detailed subcatchments: list of subcatchments whose results are to be reported. The default is blank.
- Timestep detailed nodes I and II: list of nodes whose results are to be reported. The default is blank. A maximum of 40 nodes can be written in each of them.
- Timestep detailed links: list of links whose results are to be reported. The default is blank.

Tab IBER OPTIONS
================

.. figure:: img/iber-options.png

   Iber options.

The following options are available:

Numerical scheme
----------------

- Numerical scheme: defines the numerical scheme for the Saint-Venant equations used in calculating surface flow. Available options are *1st Order*, *2nd Order*, *DHD*  and *DHD Basin*.
  The default is *DHD*.
- CFL: Courant-Friedrichs-Lewy condition. The user must set the value.
  If a very high value is set, the computation time will be reduced, but convergence issues may arise in the solution of the equations.
  A value of 0.45 can be considered appropriate as a starting point, and it can be lowered to 0.3 if convergence problems are observed.
- Max time increment: sets the maximum value of the time step used by the program to integrate the flow equations.
  This is a maximum value. In practice, the time step used during the simulation will be the minimum between this value and the one computed based on the CFL condition. The default is 1.
- Wet-dry limit: this is the depth threshold above which an element is considered wet.
  Below this value, the element is considered dry, and therefore no computations are performed on it, unless it becomes wet.
  While in river engineering, a threshold of 0.01 m is generally reasonable, in some cases this value could be reduced to as little as 0.001 m. The default is 0.0001.
- Molecular viscosity molecular viscosity coefficient applied to the flow to represent numerical diffusion effects. The default is 0.000001.
 
.. important:: DHD and DHD Basin schemes must not be used for hydraulic simulations

Time & Simulation control
-------------------------

- Results 2D time interval: time interval, in seconds, that defines how often a 2D result is saved during the simulation. This must match the *Report step* value.
  The default is 300.
- Timeseries time interval: time interval, in seconds, between data records in the time series. If not defined or greater than the *Result 2D time interval*, we use that value.
  The default is 300. 

Hydrological processes
----------------------

- Start time: simulation start time, in seconds. The default is 0.
- Precipitation: selects the type of precipitation applied in the model. The available options are *Hyetograph*, *Raster* and *No rain*. The default is *No rain*.
- Set rainfall raster: allows to choose between the defined precipitation rasters.
- Losses method: method used to calculate infiltration losses. The default is *SCS*.
- CN multiplier: multiplier factor applied to the Curve Number to adjust runoff losses. The default is 1.
- Ia: initial abstraction. Storage ratio before the start of flow. The default is 0.2.  

Tab IBER RESULTS
================

.. figure:: img/iber-results.png
  
  Iber results. In the case of the figure above, the results Depth and Velocity will be displayed. 

The following options are available:

Hydrodynamics
-------------

- Depth: water depth results, in meters, in each mesh cell over time.
- Velocity: flow velocity result, in m/s, in each mesh cell over time.
- Specific discharge: specific discharge result, in m²/s
- Water elevation: total water level result, in meters, the sum of the ground elevation plus the water depth.

Maximums
--------

- Maximum depth: maximum water depth, in meters, reached in each cell during the simulation.
- Maximum velocity: maximum flow velocity, in m/s, reached in each cell during the simulation.
- Maximum specific discharge: maximum specific flow rate, in m²/s, during the simulation.
- Maximum water elevation: maximum total water level, in meters, during the simulation.

Other results
-------------

- Energy: represents the total energy of the flow, calculated as the sum of the water level and the kinetic energy.
- Froude number: Froude number indicating the hydraulic flow regime: subcritical (Fr<1), critical (Fr=1) or supercritical (Fr>1).
- Local time step: local time step calculated according to the Courant-Friedrichs-Lewy (CFL) stability condition.
- Maximum local time step: maximum allowable value of the local time step in each model cell, which limits the time increment calculated according to the Courant condition.

Hazard
------

- Hazard RD9/2008: hydraulic hazard criterion defined by the Spanish Ministry of the Environment, which classifies risk based on water depth and flow velocity. 
- Hazard ACA 2003: hazard criterion of the Catalan Water Agency (2003), which classifies risk zones based on water depth and flow velocity.
- Pedestrians: evaluates flow hazards for pedestrians, considering water depth and velocity as determining stability factors (UPC criterion).
- Vehicles: evaluates the safety of vehicles against entrainment by currents, based on hydraulic parameters such as water depth and flow velocity (Australian criterion (Shand et al., 2011)).

Raster results
--------------

- Raster results: interpolation method for raster results. The available options are *Linear interpolation* and *Nearest interpolation*. The default is *Linear interpolation*.
- Cell size: cell size of the output rasters, in meters. The default is 100.
- Maximums at the end: adds one more timestep at the end of the result rasters with the maximum values obtained.
- Use raster frame: allows to delimit the geographic area where the raster results will be generated. The parameters are defined in the following group, *Raster results frame*.

Raster results frame
--------------------

Allows to specify the coordinates of the raster boundary.

Tab IBER PLUGINS
================

.. figure:: img/iber-plugins.png

    Iber plugins.

The following options are available:

- Only inlets or complete network: allows to choose whether to simulate only surface runoff (only inlets) or to include the complete drainage network (complete network).
  The default is *Complete network*.
- Enable or disable outlet loss: enables or disables the consideration of energy losses in the model outputs.

Tab CHECK PROJECT
-----------------

.. figure:: img/check-project-tab.png

    Check project.

Sets maximum and minimum values that can be included or excluded, for parameters:
manning, cellsize, sfactor, slope, street_vol, orifice_cd, roughness, mfactor, ufactor, outlet_vol and weir_cd.

Tab RASTER OPTIONS
------------------

.. figure:: img/raster-options.png

    Raster options.

Set the maximum and minimum values for raster results, sets the symbology color ramp, and allows you to exclude values for the parameters:
depth, velocity, water elevation, hazard ACA, severe hazard RD9-2008, local time step, specific discharge X, specific discharge Y, energy,
Froude, infiltration rate, rain depth, velocity X, velocity Y, water performance, max depth, max velocity, max water elevation, max hazard ACA,
max severe hazard RD9-2008, max local time step and max specific discharge.

.. important:: The maximum and minimum configuration will only work with the custom symbology mode.

.. note:: The execution can output more rasters than the available to configure on this dialog. They will get imported too, but with default configuration.

