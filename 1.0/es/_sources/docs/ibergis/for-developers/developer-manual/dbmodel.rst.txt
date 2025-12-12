========
DB Model
========

.. only:: html

   .. contents::
      :local:

This section describes the database model structure and organization used by IberGIS.

Data File Format
================

IberGIS uses **GeoPackage (GPKG)** files as the primary data storage format. GeoPackage is an open, standards-based, platform-independent, portable, self-describing, compact format for transferring geospatial information. It is based on SQLite 3 database engine and supports both vector features and raster data.

The main project files created by IberGIS have the ``.gpkg`` extension and contain all the necessary tables, spatial data, configurations, and metadata for hydraulic modeling projects.

Database Schema Organization
============================

The database schema is organized in the ``dbmodel/`` directory within the plugin installation folder. The structure follows a modular approach, separating different aspects of the database into logical components.

SQL Files Structure
-------------------

The database model is defined through multiple SQL files organized in subdirectories.

DDL (Data Definition Language)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Located in ``dbmodel/ddl/ddl.sql``.

This file contains all the table definitions, including:

- **Configuration tables:** Store plugin parameters and user configurations.
- **Catalog tables:** Define available types and categories for various elements (boundary scenarios, materials, curves, etc.).
- **Feature tables:** Store the main hydraulic and geometric elements.
- **System tables:** Manage internal plugin operations and form configurations.
- **Geometry tables:** Store spatial features for grounds, roofs, inlets, conduits, nodes, and other elements.

All tables include SQLite type checking constraints to ensure data integrity.

DML (Data Manipulation Language)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Located in ``dbmodel/dml/dml.sql``.

This file contains the initial data population statements:

- **Spatial reference system (SRID) configuration:** Sets up the coordinate reference system.
- **System tables initialization:** Populates configuration and metadata tables.
- **Catalog data:** Inserts default values for all catalog tables.
- **Form field definitions:** Configures the dynamic forms used throughout the plugin.
- **Type values:** Populates dropdown lists and selectable options.

The DML file uses placeholders like ``<SRID_VALUE>`` that are dynamically replaced when creating new projects.

Triggers
^^^^^^^^

Located in ``dbmodel/trg/``.

- **trg_create.sql:** Contains CREATE triggers that:

  - Auto-generate unique codes for new elements (e.g., 'J1', 'C5', 'RF10').
  - Maintain topology relationships between nodes and arcs.
  - Update parent-child table relationships.
  - Synchronize geometry changes across related tables.

- **trg_delete.sql:** Contains DELETE triggers that:

  - Cascade deletions to related tables.
  - Clean up orphaned records.
  - Maintain referential integrity.

Functions
^^^^^^^^^

Located in ``dbmodel/fct/``.

- **fct_after_import_ground_geometries.sql:** Post-processing for ground polygon imports.
- **fct_after_import_inlet_geometries.sql:** Post-processing for inlet point imports.
- **fct_after_import_roof_geometries.sql:** Post-processing for roof polygon imports.
- **fct_after_import_inp.sql:** Post-processing after importing EPA SWMM .inp files.

These functions handle data normalization, code assignments, and relationship establishment after bulk imports.

Internationalization (i18n)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Located in ``dbmodel/i18n/``.

Contains language-specific DML files for multiple locales:

- **en_US/dml.sql:** English (United States).
- **es_ES/dml.sql:** Spanish (Spain).
- **es_CR/dml.sql:** Spanish (Costa Rica).

These files provide translated values for user-facing strings stored in the database, such as field labels, tooltips, and messages.

Reports Database
^^^^^^^^^^^^^^^^

Located in ``dbmodel/rpt_gpkg/``.

Defines a separate schema for storing simulation results:

- **ddl.sql:** Tables for storing EPA SWMM simulation results (nodes, arcs, flow summaries, etc.).
- **dml.sql:** Initial configuration for result tables.

The reports database structure allows IberGIS to import and visualize simulation outputs directly in QGIS.

System Tables
^^^^^^^^^^^^^

Located in ``dbmodel/sys_gpkg/sys_gpkg.sql``.

Creates system-level tables required by GeoPackage and GDAL/OGR:

- **gpkg_ogr_contents:** Tracks feature counts for each table.
- Additional metadata tables for GeoPackage compliance.

Example Data
^^^^^^^^^^^^

Located in ``dbmodel/example/example_data.sql``.

Provides sample data for testing and demonstration purposes, including:

- Boundary conditions with geometries.
- Sample ground, roof, and inlet features.
- Pre-configured scenarios.
- Example hyetographs and time series.

Database Initialization
=======================

The file ``dbmodel/init.sql`` serves as the entry point for database creation. It references and executes all other SQL files in the correct order to build a complete project database.

The typical initialization sequence is:

1. Create system GeoPackage tables.
2. Execute DDL to create all tables.
3. Execute DML to populate initial data.
4. Apply internationalization for the selected language.
5. Create triggers for data integrity.
6. Load example data (if creating a sample project).

Version Control and Updates
===========================

Located in ``dbmodel/updates/``.

The plugin includes a versioning system organized by major/minor/patch numbers:

- **updates/1/1/0/:** Contains update scripts for version 1.1.0.

  - **changelog.txt:** Describes changes in this version.
  - **ddl.sql:** Schema modifications.
  - **dml.sql:** Data migrations.

This structure allows IberGIS to automatically upgrade existing project databases when users update the plugin to a newer version.

.. important:: Updates must also be applied to the base files for new projects. For example, if version 1.1.0 introduces a new table, you must update ``dbmodel/ddl/ddl.sql`` to include the new table definition in addition to updating ``dbmodel/updates/1/1/0/ddl.sql``.

Key Features
============

Type Checking
-------------

All tables use SQLite's ``typeof()`` function in CHECK constraints to enforce strict type validation, preventing data corruption from incorrect value types.

Spatial Data
------------

Geometric features use the GeoPackage geometry type and are registered in the standard ``gpkg_geometry_columns`` table. Supported geometry types include:

- POINT (inlets, junctions, storage, outfalls, dividers, hyetographs).
- LINESTRING (conduits, orifices, weirs, pumps, outlets).
- POLYGON (grounds, roofs).
- MULTILINESTRING (boundary conditions).

Foreign Keys
------------

The database extensively uses foreign key constraints to maintain referential integrity between related tables. Cascading updates and restricted deletions ensure data consistency.

JSON Fields
-----------

Some configuration tables use JSON-formatted TEXT fields to store complex structured data, such as form widget parameters and additional metadata.
