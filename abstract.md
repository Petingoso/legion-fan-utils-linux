-main window
-there it'll have the most important toggles: on, off, system startup,...

- tabbed option:fancurve
-list menu: GPU curve, CPU curve,...
-draw graphics from points

-save button which will save them to a config file, apply which will call the kernel module
maybe add a service so it gets activated after suspend or fn q, maybe add profiles

(service would every X minutes check the fan curve against config, else enable it)

(adding a profile seems easy too, basically just changing the config file used, a docking icon could do that, also add to main GUI)

as for actual programming
-parse current configs once
-draw everything
-add changes to a config file, when needed parse it and apply curves
