//
// This script is used to create the components for a printable inkjet head, and is based
// on the design by Adrian Bowyer (http://www.thingiverse.com/thing:5152). This script
// is parameterized so that different sized piezos and nozzle plates can be used.
//
// The main difference from the #5152 version is that only a single o-ring is used.
//
// License: GPL V2
// 
// Version 0.1, Dec 17th, 2010 - Created by madscifi - This has not yet been printed 
// Modified by Adrian to allow for 2 or 1 O rings and to make the clamp plate thicker in the middle. 
// Version 0.3, Dec 18th, 2010 - fix piezo clamp clearance/width bug
//      - rework clamp o-ring addition so that the body height is adjusted based on the height of the second o-ring
//      - remove clamp wire cutout if second o-ring is used
//      - reposition bolt holes so it is equidistant from the piezo wall and the body wall.
//      - automatically compute width of tube clamp

//
// If gen_for_stl is 0, the various components are positioned as an "exploded" stack,
// so it is easy to see how they interact. 
//
// If gen_for_stl is 1, the various components are positioned to be printed as a single
// plate, with the components distributed along the x axis.
//
// As originally submitted this script is configured to create all components for printing
// and is configured for a 20 mm diameter piezo and a 2 mm high o-ring.

gen_for_stl = 1;	   		// set to 1 if the enabled component should be positioned for printing

//
// The following variables control the various dimensions - all in mm
// These will likely need to be changed, depending on the specific piezo,
// o-ring and nozzle plate used.
//

piezo_diameter=20;		// diameter of piezo disk
piezo_height=0.5;		// height of piezo disk

o_ring_body_height=2;		// height of body o-ring (the one that defines the ink chamber)
o_ring_clamp_height=0;		// height of clamp o-ring (the one between the clamp and the piezo)
						// 0 indicates that this o-ring is not used.
						// If this o-ring is used then the cutout for the wire in the clamping
						// component is not created.
nozzle_plate_height=2;

body_xy_extra=3; 		// extra space beyond the piezo that the body uses.
body_extra_height=3;

bolt_hole_diameter=3;	// diameter of bolt holes

tube_diameter = 3;		// diameter of tubing
tube_clamp_extra_height = 2;	// extra height ( over tube height) of tube clamp.

//
// The following variables might need to be tweaked, or they might be
// fine as is. It is probably best to do a test print before changing them.
//

nozzle_ledge_height=2;		// height of the ledge used to support the nozzle plate
nozzle_ledge_inset=5;		// inset of the ledge used to support the nozzle plate

piezo_clearance=0.1;			// allowance between the body and the piezo in the xy plane

piezo_clamp_clearance=0.1;	// allowance between the body and the piezo clamp ring
piezo_clamp_width=2;		// width of the piezo clamp pressure ring

piezo_clamp_square_height=3;	// height of piezo clamp support square

wire_cut_width=3;			// width of wire cutout

bolt_hole_resolution=10;		// number of "sides" to use when generating the bolt holes
large_hole_resolution=50;		// number of "sides" to use when generating the larger circular features

component_stl_spacing=5;		// space between components when generating stl

//
// The following should not need to be modified unless the basic design is being changed.
//

body_xy_size=piezo_diameter+body_xy_extra;

body_height=nozzle_ledge_height+nozzle_plate_height+o_ring_body_height+o_ring_clamp_height+piezo_height+body_extra_height;

// the bolt hole walls (and center) should be equidistant from the body walls and the piezo cutout wall,
bolt_a = ((piezo_diameter-piezo_clearance)/2)*sin(45);
bolt_b = (body_xy_size/2);
bolt_xy_pos=(sin(45)*bolt_b+bolt_a)/(sin(45)+1);

tube_clamp_height = tube_diameter + tube_clamp_extra_height;
tube_clamp_width = (body_xy_size/2 - bolt_xy_pos)*2;

//
// Body component
//

  translate(v = [0,0,gen_for_stl==0?0:body_height/2])
  {
    difference()
    {
      // starting body block
      cube(size=[body_xy_size,body_xy_size,body_height],center=true);
      
      // chamber cutout
      translate(v = [0, 0, nozzle_ledge_height])
      {
        cylinder(h = body_height, r=(piezo_diameter+piezo_clearance)/2, center = true, $fn=large_hole_resolution);
      }

      // nozzle cutout
      cylinder(h = body_height+1, r=(piezo_diameter-nozzle_ledge_inset)/2, center = true, $fn=large_hole_resolution);

      // cut out for piezo wires
      translate(v = [body_xy_size/2, 0, body_height/2-(body_extra_height+o_ring_clamp_height+piezo_height+(o_ring_body_height/8))/2])
      {
        cube(size=[body_xy_size,wire_cut_width,body_extra_height+o_ring_clamp_height+piezo_height+(o_ring_body_height/8)],center=true);
      }

      // bolt cutouts
      translate(v = [bolt_xy_pos, bolt_xy_pos, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
      translate(v = [-bolt_xy_pos, -bolt_xy_pos, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
      translate(v = [bolt_xy_pos, -bolt_xy_pos, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
      translate(v = [-bolt_xy_pos, bolt_xy_pos, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
    }
  }

//
// Piezo Clamp
//

  translate(v = [gen_for_stl==0?0:-(body_xy_size+component_stl_spacing),0, gen_for_stl==0?body_height+5:piezo_clamp_square_height/2])
  {
    rotate(a=[0, gen_for_stl==0?0:180,0])
    {
      union() {
        difference()
        {
          // starting square (structural support)
          cube(size=[body_xy_size,body_xy_size,piezo_clamp_square_height],center=true);

          // bolt cutouts
          translate(v = [bolt_xy_pos, bolt_xy_pos, 0])
          {
            cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
          }
          translate(v = [-bolt_xy_pos, -bolt_xy_pos, 0])
          {
            cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
          }
          translate(v = [bolt_xy_pos, -bolt_xy_pos, 0])
          {
            cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
          }
          translate(v = [-bolt_xy_pos, bolt_xy_pos, 0])
          {
            cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
          }
        }

        // pressure ring
        translate(v = [0,0, -(body_extra_height+(o_ring_body_height/2))/2-piezo_clamp_square_height/2+0.01])
        {
          difference()
          {
            // starting ring material
            cylinder(
	      h = body_extra_height+(o_ring_body_height/2),
	      r=(piezo_diameter-piezo_clamp_clearance)/2,
	      center = true,
	      $fn=large_hole_resolution);
	      
            // hollow out ring
            cylinder(
	      h = body_extra_height+(o_ring_body_height/2)+1,
	      r=(piezo_diameter-piezo_clamp_clearance)/2-piezo_clamp_width,
	      center = true,
	      $fn=large_hole_resolution);

            // cut out for piezo wire - only used if o_ring_clamp_height is 0
	    if( o_ring_clamp_height == 0 )
            {
              translate(v = [body_xy_size/2, 0, 0])
              {
                cube(size=[body_xy_size,wire_cut_width,body_extra_height+(o_ring_body_height/2)],center=true);
              }
            }	      
          }
        }
      }
    }
  }

//
// Tube Clamp
//

  translate(
    v = [
      gen_for_stl==0?0:body_xy_size/2+tube_clamp_width/2+component_stl_spacing,
      gen_for_stl==0?(body_xy_size-tube_clamp_width)/2:0,
      gen_for_stl==0?-(body_height+tube_clamp_height)/2-5:tube_clamp_height/2])
  {
    rotate(a=[0, 0, gen_for_stl==0?0:90])
    {
    difference()
    {
      // starting tube clamp body
      cube(size=[body_xy_size,tube_clamp_width,tube_clamp_height],center=true);

      // tube cutout
      translate(v = [0,0,(tube_clamp_height-tube_diameter)/2])
      {
        cube(size=[tube_diameter,tube_clamp_width+2,tube_diameter],center=true);
      }

      // bolt hole cutouts
      translate(v = [bolt_xy_pos,0, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
      translate(v = [-bolt_xy_pos,0, 0])
      {
        cylinder(h = body_height+1, r=(bolt_hole_diameter)/2, center = true, $fn=bolt_hole_resolution);
      }
    }
  }
}
