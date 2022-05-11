# ITA_multiphase


This interface tracking algorithm (ITA) simulates immiscible fluid-fluid displacement processes in two-dimentional porous media in the quasi-static (capillary-dominated) regime under different wetting conditions (controlled by the contact angle).

run "main_demo.m" for a demonstration.

The Initialization includes two steps:
  1. the porous medium geometry is read either from an image (option 1), or from a mat file containing the x,y coordinates for the grain boundaries (option 2).
  2. setup the initial meniscus location (inlet), as well as the oulet location.

Then, the main loop is executed by calling "proceed" function.

----------------------------------------
Please cite the following article if you find this algorithm useful:

Wang, Z., Pereira, J.-M., Sauret, E., Aryana, S. A., Shi, Z., &amp; Gan, Y. (2022, February 26). A pore-resolved interface tracking algorithm for simulating multiphase flow in arbitrarily structured porous media. Advances in Water Resources. Retrieved May 11, 2022, from https://www.sciencedirect.com/science/article/pii/S030917082200029X 
