Title: Context Description
Author: Matthew D. Jordan
Web: http://www.scenic-shop.com


Context
=======
####*Put your Project data in context.*

-----------------------------------

Purpose
-------

Context is an AutoCAD-based content manager for project data.  The core premise of Context is that by automagically determining the currently open drawing's project and task (the file's context, if you will), navigation and management of related files is greatly simplified.  Context allows you to interact with the task and project files using a simple, intuitive interface.  Focus on your data, not file locations, naming codes, or file managers; Context alleviates the tedium.


Features
--------

#### See Only What Matters

A task's files are abstracted into several categories that make it easier to browse through your project's data.  Context will automatically sort files by category; you can browse only the files you need.  Some of the file categories are listed below:

* Bills Of Materials
* Analysis and Calculation Documents
* Issued Documents
* CNC Drawings (Conventional Machining, Router, Waterjet, and Scratches)
* Drawings (Fabrication, Model, Sketches, Auxillary, etc.)


Files are displayed with the following properties:

|File Type:         |   Description |   Revision | Date | Extension | Type  |
|:------------------|:-------------:|:----------:|:----:|:---------:|:-----:|
|BOMs               |       X       |       X    |      |           |       |
|File Versions      |       X       |       X    |      |           |       |
|Issued Documents   |       X       |       X    |  X   |           |   X   |
|Drawings           |       X       |       X    |      |           |   X   |
|CNC Drawings       |       X       |       X    |      |           |   X   |
|Analysis Files     |       X       |       X    |      |     X     |       |
[Chart of File Properties]


#### File Actions

Context is not limited to only showing your task's data in a sane, easy to navigate manner.  It allows you to perform actions on a files:

* Open file
* Send via outlook as a hyperlink, or as an attachment
* Copy the file path
* Reveal the file in Windows Explorer
* Insert DWGs, PDFs, and images into AutoCAD as external references. 


#### Manage Versions and Releases

* Modify the release number right from Context's *Save As* dialogue box.
* Automatically increment the current document's release number and archive the old version into the proper archive directory.
* Browsing a file's version history is just one click away.
* Context can alert you when opening an older version of a file.


#### New File

Context's *New File* command provides several improvements to AutoCAD's stock *new file* command:

* Determine the new file's project and task based on the current context (editable by the user).
* Auto-populate the DWG file properties based on the selected context.
* Select the new file's type from a drop down -- then sit back and let Context select the proper file template, file name format, and location (editable by the user).


#### Save As

Context's *Save As* command provides several improvements to AutoCAD's stock *save as* command:

* Provides a simple interface for incrementing release numbers.
* Allows the user to specify if a file is "in progess", and automatically manages the corresponding storage location.
* Copy a file into another task or project.
* Save to a pre-determined file format based upon the file's type. (Useful for CNC files)
* Auto-populate the DWG file properties based on the target context, preview the properties for user editing.


#### Browse Other Projects and Tasks

The Browse pane lets you root through files belonging to other projects and tasks.  The same set of actions available in the Current Drawing pane are available in the Browse pane. (Except for **Show Previous File Releases**.)


#### Recents

Context remembers your recent projects and tasks, making it easy to switch back and forth.


#### Favorites

Add favorite projects and tasks so they'll always be on hand.  Manage your favorites from an options dialogue or add them on the fly, without interupting your work. 


#### User Configurable

* Set default templates for each drawing type
* Add links to user-specific templates
* Set default **Save As** file format for each drawing type
* Change the default "Drafted by" drawing property
* Change the default "Location Number" drawing property
* Change the default location for all user-specific project data
* Manage Favorites and Recents project and task lists