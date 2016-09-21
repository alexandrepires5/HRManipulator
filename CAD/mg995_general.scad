include <mg995_motor.scad>;
include <measures.scad>;
include <mg995_horn.scad>;

/* ------ if base_servo == "mg995" ------*/
//hinge
support_z_hinge = mg995_width + 0.9;
support_width_hinge = (mg995_total_length - mg995_length)/2 + 3;
servo_axis_clear = (mg995_horn_length - mg995_horn_1stcircle/2 + 10);
servo_HTot = mg995_total_height + mg995_horn_height+2; //A
bigscrew = mg995_horn_bigscrew;
smallscrew = mg995_horn_smallscrew;
smallscrew_length = mg995_horn_smallscrew_length;
smallscrew_head_d1 = mg995_horn_head_d1;
smallscrew_head_d2 = mg995_horn_head_d2;
//sleeve
support_width_sleeve = (mg995_total_length - mg995_length)/2 + 1;
servo_L = mg995_length + 0.9;
servo_H = mg995_partial_height_b + 4;
support_z_sleeve = mg995_width + 0.9;
servo_bottom_cylinder_diameter = mg995_bottom_cylinder_diameter;
//servo_fixation_holes
servo_fixation_hole_x = mg995_fixation_hole_x ;
servo_fixation_hole_y = mg995_fixation_hole_y ;
servo_fixation_hole_z = mg995_fixation_hole_z ;
servo_hole_diameter = 2;

/* ----------------------------- */
sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
sleeve_hinge_size = sleeve_hinge_dist*2;
hinge_sleeve_dist = 5;
hanger_height = support_width_hinge + 0.3;


module servo_sleeve(type = "side_hole", hole = "two", base_servo = "mg995"){
 
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  //translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
      translate([-servo_L + 9.5,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}



module servo_hinge(hinge_servo = "mg995"){

	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg995_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}








module left_side(){
    //rotate($t*360,0,0) 
        translate([0,-mg995_length/3,0]) cube(size = [mg995_width,mg995_length/3,mg995_height], center = true);
}


module right_side(){
    cube(size = [mg995_width,mg995_length*2/3,mg995_height], center = true);
}

module motor_sleeve(){
    //motor_mg995();
    //translate([0,-servo_L/2,servo_H/2-5]) rotate([90,0,-90])  
    //    #servo_sleeve();
    //translate([0,10.9,servo_H-5]) rotate([0,-90,$t*180-90])
    //    servo_hinge();
}

//translate([servo_L-4.5,0,0])rotate([0,360*$t,0], v = [1,1,0]) 
//    servo_sleeve();

motor_sleeve();

