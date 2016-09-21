include <motor_mg946r.scad>;
include <measures.scad>;

/* ------ if base_servo == "mg946r" ------*/
//hinge
support_z_hinge = mg946r_width + 0.9;
support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 3;
servo_axis_clear = (mg946r_horn_length -mg946r_horn_1stcircle/2 + 3);
servo_HTot = mg946r_total_height + 2; //A
bigscrew = mg946r_horn_bigscrew;
smallscrew = mg946r_horn_smallscrew;
smallscrew_length = mg946r_horn_smallscrew_length;
smallscrew_head_d1 = mg946r_horn_head_d1;
smallscrew_head_d2 = mg946r_horn_head_d2;
//sleeve
support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
servo_L = mg946r_length + 0.9;
servo_H = mg946r_height + 0.5;
support_z_sleeve = mg946r_width + 0.9;
servo_bottom_cylinder_diameter = mg946r_bottom_cylinder_diameter;
//servo_fixation_holes
servo_fixation_hole_x = mg946r_fixation_hole_x ;
servo_fixation_hole_y = mg946r_fixation_hole_y ;
servo_fixation_hole_z = mg946r_fixation_hole_z ;
servo_hole_diameter = 2;

/* ----------------------------- */
sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
sleeve_hinge_size = sleeve_hinge_dist*2;
hinge_sleeve_dist = 5;
hanger_height = support_width_hinge + 0.3;


module servo_sleeve(type = "side_hole", hole = "two", base_servo = "mg946r"){
 
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
      translate([-servo_L + 8,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module horn_single(horn = "mg946r"){
    if(horn == "mg946r"){
        linear_extrude(height = 7, center = false)
        hull(){
            translate([mg946r_horn_length -mg946r_horn_1stcircle/2, 0, 0]) circle(d = mg946r_horn_1stcircle, $fn = 32);
            circle(d = mg946r_horn_2ndcircle, $fn = 32);
        }
    }
    else if (horn == "mg946r"){
      linear_extrude(height = mg946r_horn_height, center = false)
      hull(){
       translate([mg946r_horn_length- mg946r_horn_1stcircle/2, 0, 0]) circle(d = mg946r_horn_1stcircle, $fn = 32);
       circle(d = mg946r_horn_2ndcircle, $fn = 32);
      }
    }
    else if (horn == "sg90"){
        linear_extrude(height = sg90_horn_height, center = false)
      hull(){
       translate([sg90_horn_length-sg90_horn_1stcircle/2, 0, 0]) circle(d = sg90_horn_1stcircle, $fn = 32);
       circle(d = sg90_horn_2ndcircle, $fn = 32);
      }
    }
}

module servo_hinge(hinge_servo = "mg946r"){

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
                horn_single(hinge_servo);
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}








module left_side(){
    //rotate($t*360,0,0) 
        translate([0,-mg946r_length/3,0]) cube(size = [mg946r_width,mg946r_length/3,mg946r_height], center = true);
}


module right_side(){
    cube(size = [mg946r_width,mg946r_length*2/3,mg946r_height], center = true);
}

module motor_sleeve(){
    motor();
    translate([0,-servo_L/2,servo_H/2-4]) rotate([90,0,-90])  
        #servo_sleeve();
    translate([0,12.5,servo_H]) rotate([0,-90,$t*180-90])
        servo_hinge();
}

//translate([servo_L-4.5,0,0])rotate([0,360*$t,0], v = [1,1,0]) 
//    servo_sleeve();

motor_sleeve();

