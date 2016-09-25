include <measures.scad>
include <motor.scad>
include <horn.scad>

/* ------ if base_servo == "s8330m" ------*/
//hinge
support_z_hinge = s8330m_width + 0.9;
support_width_hinge = (s8330m_total_length - s8330m_length)/2 + 3;
servo_axis_clear = (s8330m_horn_length -s8330m_horn_1stcircle/2 + 3);
servo_HTot = s8330m_total_height + 0.5; //A
bigscrew = s8330m_horn_bigscrew;
smallscrew = s8330m_horn_smallscrew;
smallscrew_length = s8330m_horn_smallscrew_length;
smallscrew_head_d1 = s8330m_horn_head_d1;
smallscrew_head_d2 = s8330m_horn_head_d2;
//sleeve
support_width_sleeve = (s8330m_total_length - s8330m_length)/2 + 3;
servo_L = s8330m_length + 0.9;
servo_H = s8330m_height + 0.5;
support_z_sleeve = s8330m_width + 0.9;
servo_bottom_cylinder_diameter = s8330m_bottom_cylinder_diameter;
//servo_fixation_holes
servo_fixation_hole_x = s8330m_fixation_hole_x ;
servo_fixation_hole_y = s8330m_fixation_hole_y ;
servo_fixation_hole_z = s8330m_fixation_hole_z ;
servo_hole_diameter = 2;

/* ----------------------------- */
sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
sleeve_hinge_size = sleeve_hinge_dist*2;
hinge_sleeve_dist = 5;
hanger_height = support_width_hinge + 0.3;

module generic_screw(d = 3, h = 10, head_h = 1, head_top_d = 5, head_bot_d = 3, thread = 0) {
    union() {
        translate([0, 0, -h])
        cylinder(d = d - thread, h = h);
        translate([0, 0, -head_h])
        cylinder(h = head_h + 1e-3, d1 = max(d, head_bot_d), d2 = head_top_d);
    }
}

module M25_screw_hole(h = 10) {
  generic_screw(h = h, d = 2.9, head_top_d = 4,  head_bot_d = 2.5);   
}

module plate() {
    difference() {
        translate([0, 0, -3/2])
        cube([18, 12, 3], center = true);
        
        translate([-6, -3, 0])
        M25_screw_hole(); 
        translate([-6,  3, 0])
        M25_screw_hole(); 
        translate([6, -3, 0])
        M25_screw_hole(); 
        translate([6,  3, 0])
        M25_screw_hole(); 
    }
}

module plate_2(){
    difference(){
        union(){
            cube([15,20,3], center = true);
        }
        union(){
            translate([5,7.5,-1.5]) cylinder(d = 2.5, h = 10, $fn=32);
            translate([5,-7.5,-1.5]) cylinder(d = 2.5, h = 10, $fn = 32);
            translate([-5,7.5,-1.5]) cylinder(d = 2.5, h = 10, $fn = 32);
            translate([-5,-7.5,-1.5]) cylinder(d = 2.5, h = 10, $fn = 32);
        }
    }
}

module servo_sleeve_s8330m(type = "side_hole", hole = "one"){
 
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
	    #cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    #cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    #cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    #cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 2, -servo_H - 3.4 + 1e-3, -4.2/2])
	    #cube([support_width_sleeve, 7 + 8, 4.1]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -3.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 3.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -3.4 - servo_H, -4.2/2])
	      cube([servo_L, 3.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([8.9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  translate([-servo_L + 12,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}
}


module servo_hinge_s8330m(hinge_servo = "s8330m"){

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
            cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                #horn_s8330m_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = s8830m_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module sleeve_hinge_s8330m(screw){
  difference(){
      union(){
         translate([-sleeve_hinge_size/2+2 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-4, sleeve_hinge_dist + 2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_s8330m();
    
  if(screw == "one") servo_sleeve_s8330m(type = "side_hole", hole = "one");
      else servo_sleeve_s8330m(type = "side_hole", hole = "two");
     }
  }
  
}

module hinge_sleeve_alt_sleeve_s8330m(screw){
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_s8330m(type = "bottom", hole = "one");
        else servo_sleeve_s8330m(type = "bottom_hole", hole = "two");
    }
// ------- translate II
    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+10, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
 
// ------ translate I    
//    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear-4, -servo_L - (0.5) * support_width_sleeve , 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
//    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+11, -servo_L - (0.5) * support_width_sleeve, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}

module servo_sleeve_mg946r(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 2;
    servo_L = mg946r_length + 0.5;
    servo_H = mg946r_height + 0.5;
    servo_fixation_hole_x = mg946r_fixation_hole_x ;
    servo_fixation_hole_y = mg946r_fixation_hole_y ;
    servo_fixation_hole_z = mg946r_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = mg946r_width + 0.25;
    servo_bottom_cylinder_diameter = mg946r_bottom_cylinder_diameter;
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    
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


module servo_hinge_mg946r(hinge_servo = "mg946r"){
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 2;
    support_z_hinge = mg946r_width + 0.25;
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    servo_axis_clear = (mg946r_horn_length -mg946r_horn_1stcircle/2 + 3);
    servo_HTot = mg946r_total_height +0.1; //A
    bigscrew = mg946r_horn_bigscrew;
    smallscrew = mg946r_horn_smallscrew;
    smallscrew_length = mg946r_horn_smallscrew_length;
    smallscrew_head_d1 = mg946r_horn_head_d1;
    smallscrew_head_d2 = mg946r_horn_head_d2;
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
                #horn_mg946r_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_mg946r(screw){

    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_mg946r();  
    }
// translate II
    translate([-17.1*abs(servo_axis_clear-servo_H)-6, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-16, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    
// -------- translate I
//    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+5, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
//    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+20, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    
  }
}


module hinge_sleeve_alt_sleeve_mg946r(screw){
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3); 
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_mg946r(type = "bottom", hole = "one");
        else servo_sleeve_mg946r(type = "bottom_hole", hole = "two");
        }
    
//    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
//    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
    
    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+9, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+19, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    
    }
}


module sleeve_hinge_mg946r(screw){
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    servo_axis_clear = (mg946r_horn_length -mg946r_horn_1stcircle/2 + 3);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+4 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-10, sleeve_hinge_dist +2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_mg946r();
    
  if(screw == "one") servo_sleeve_mg946r(type = "side_hole", hole = "one");
      else servo_sleeve_mg946r(type = "side_hole", hole = "two");
     }

  }
  
}

module servo_sleeve_hk15328(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 2;
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height;
    servo_fixation_hole_x = hk15328_fixation_hole_x ;
    servo_fixation_hole_y = hk15328_fixation_hole_y ;
    servo_fixation_hole_z = hk15328_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = hk15328_width + 0.25;
    servo_bottom_cylinder_diameter = hk15328_bottom_cylinder_diameter;
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    
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
      translate([-servo_L + 10.45,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_hk15328(hinge_servo = "hk15328"){
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 2;
    support_z_hinge = hk15328_width + 0.25;
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    servo_HTot = hk15328_total_height + 2; //A
    bigscrew = hk15328_horn_bigscrew;
    smallscrew = hk15328_horn_smallscrew;
    smallscrew_length = hk15328_horn_smallscrew_length;
    smallscrew_head_d1 = hk15328_horn_head_d1;
    smallscrew_head_d2 = hk15328_horn_head_d2;
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
                horn_hk15328();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_hk15328(screw){
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_hk15328();  
    }

    {
    translate([-17.1*abs(servo_axis_clear-servo_H)-6, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-16, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}

module hinge_sleeve_alt_sleeve_hk15328(screw){
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_hk15328(type = "bottom", hole = "one");
        else servo_sleeve_hk15328(type = "bottom_hole", hole = "two");
    }

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+10, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}

module sleeve_hinge_hk15328(screw){
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+5 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-12, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_hk15328();
    
  if(screw == "one") servo_sleeve_hk15328(type = "side_hole", hole = "one");
      else servo_sleeve_hk15328(type = "side_hole", hole = "two");
     }
  }
  
}

module servo_sleeve_hd1160a(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (hd1160a_total_length - hd1160a_length)/2 + 2;
    servo_L = hd1160a_length + 0.9;
    servo_H = hd1160a_height;
    servo_fixation_hole_x = hd1160a_fixation_hole_x ;
    servo_fixation_hole_y = hd1160a_fixation_hole_y ;
    servo_fixation_hole_z = hd1160a_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = hd1160a_width + 0.25;
    servo_bottom_cylinder_diameter = hd1160a_bottom_cylinder_diameter;
    support_width_hinge = (hd1160a_total_length - hd1160a_length)/2 + 2;
    
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
	    translate([3, 6.5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - 3, 6.5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);

        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -2.1])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 6, 3.2]);
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
      translate([-servo_L + 8.5,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_hd1160a(hinge_servo = "hd1160a"){
    support_width_sleeve = (hd1160a_total_length - hd1160a_length)/2 + 2;
    support_z_hinge = hd1160a_width + 0.25;
    support_width_hinge = (hd1160a_total_length - hd1160a_length)/2 + 2;
    servo_axis_clear = (hd1160a_horn_length -hd1160a_horn_1stcircle/2 + 7);
    servo_HTot = hd1160a_total_height ; //A
    bigscrew = hd1160a_horn_bigscrew;
    smallscrew = hd1160a_horn_smallscrew;
    smallscrew_length = hd1160a_horn_smallscrew_length;
    smallscrew_head_d1 = hd1160a_horn_head_d1;
    smallscrew_head_d2 = hd1160a_horn_head_d2;
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
                horn_hd1160a_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = hd1160a_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_hd1160a(screw){
    servo_axis_clear = (tss10mg_horn_length - tss10mg_horn_1stcircle/2 + 3);
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_hd1160a();  
    }
    
    {
        
    translate([-17.1*abs(servo_axis_clear-servo_H)-10, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-0.3, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-20, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-0.3, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}

module hinge_sleeve_alt_sleeve_hd1160a(screw){
    support_width_hinge = (hd1160a_total_length - hd1160a_length)/2 + 2;
    support_width_sleeve = (hd1160a_total_length - hd1160a_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hd1160a_length + 0.9;
    servo_H = hd1160a_height + 0.5;
    support_z_sleeve = hd1160a_width + 0.25;
    servo_axis_clear = (hd1160a_horn_length -hd1160a_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_hd1160a(type = "bottom", hole = "one");
        else servo_sleeve_hd1160a(type = "bottom_hole", hole = "two");
    }

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+20, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+30, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}


module sleeve_hinge_hd1160a(screw){
    support_width_hinge = (hd1160a_total_length - hd1160a_length)/2 + 2;
    support_width_sleeve = (hd1160a_total_length - hd1160a_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hd1160a_length + 0.9;
    servo_H = hd1160a_height + 0.5;
    support_z_sleeve = hd1160a_width + 0.25;
    servo_axis_clear = (hd1160a_horn_length -hd1160a_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+5 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-12, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_hd1160a();
    
  servo_sleeve_hd1160a(type = "side_hole", hole = "one");
     }
  }
  
}

module servo_sleeve_tss10mg(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 2;
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height;
    servo_fixation_hole_x = tss10mg_fixation_hole_x ;
    servo_fixation_hole_y = tss10mg_fixation_hole_y ;
    servo_fixation_hole_z = tss10mg_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_bottom_cylinder_diameter = tss10mg_bottom_cylinder_diameter;
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    
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
	    translate([2.5, 5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - 2.5, 5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);

        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 6, 3.2]);
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
      translate([-servo_L + 6.5,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}

module servo_hinge_tss10mg(hinge_servo = "tss10mg"){
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_z_hinge = tss10mg_width + 0.25;
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    servo_HTot = tss10mg_total_height ; //A
    bigscrew = tss10mg_horn_bigscrew;
    smallscrew = tss10mg_horn_smallscrew;
    smallscrew_length = tss10mg_horn_smallscrew_length;
    smallscrew_head_d1 = tss10mg_horn_head_d1;
    smallscrew_head_d2 = tss10mg_horn_head_d2;
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
                horn_tss10mg_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = tss10mg_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_tss10mg(screw){
    servo_axis_clear = (hk15328_horn_length - hk15328_horn_1stcircle/2 + 3);
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_tss10mg();  
    }
    
    {
        
    translate([-17.1*abs(servo_axis_clear-servo_H)-4.5/16.5*servo_H, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-1.5, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-4.5/16.5*servo_H-10, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-1.5, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}

module hinge_sleeve_alt_sleeve_tss10mg(screw){
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_tss10mg(type = "bottom", hole = "one");
        else servo_sleeve_tss10mg(type = "bottom_hole", hole = "two");
    }
    

    translate([-17.1*abs(servo_axis_clear-servo_H)-2, -servo_L - 0.5 * support_width_sleeve+.5, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-12, -servo_L - 0.5 * support_width_sleeve+.5, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}


module sleeve_hinge_tss10mg(screw){
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+6 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-14, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_tss10mg();
    
  if(screw == "one") servo_sleeve_tss10mg(type = "side_hole", hole = "one");
      else servo_sleeve_tss10mg(type = "side_hole", hole = "two");
     }
  }
  
}

module servo_sleeve_max3002(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (max3002_total_length - max3002_length)/2 + 2;
    servo_L = max3002_length + 0.9;
    servo_H = max3002_height;
    servo_fixation_hole_x = max3002_fixation_hole_x ;
    servo_fixation_hole_y = max3002_fixation_hole_y ;
    servo_fixation_hole_z = max3002_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = max3002_width + 0.25;
    servo_bottom_cylinder_diameter = max3002_bottom_cylinder_diameter;
    support_width_hinge = (max3002_total_length - max3002_length)/2 + 2;
    
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
	    translate([2.5, 5.5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - 2.5, 5.5, 0])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);

        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -2.1])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 6, 3.2]);
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
      translate([-servo_L + 7,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}

module servo_hinge_max3002(hinge_servo = "max3002"){
    support_width_sleeve = (max3002_total_length - max3002_length)/2 + 2;
    support_z_hinge = max3002_width + 0.25;
    support_width_hinge = (max3002_total_length - max3002_length)/2 + 2;
    servo_axis_clear = (max3002_horn_length -max3002_horn_1stcircle/2 + 7);
    servo_HTot = max3002_total_height ; //A
    bigscrew = max3002_horn_bigscrew;
    smallscrew = max3002_horn_smallscrew;
    smallscrew_length = max3002_horn_smallscrew_length;
    smallscrew_head_d1 = max3002_horn_head_d1;
    smallscrew_head_d2 = max3002_horn_head_d2;
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
                horn_max3002_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = max3002_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_max3002(screw){
    servo_axis_clear = (tss10mg_horn_length - tss10mg_horn_1stcircle/2 + 3);
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_max3002();  
    }
    
    {
        
    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+3.5, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-0.3, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-servo_axis_clear+13.5, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-0.3, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}

module hinge_sleeve_alt_sleeve_max3002(screw){
    support_width_hinge = (max3002_total_length - max3002_length)/2 + 2;
    support_width_sleeve = (max3002_total_length - max3002_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = max3002_length + 0.9;
    servo_H = max3002_height + 0.5;
    support_z_sleeve = max3002_width + 0.25;
    servo_axis_clear = (max3002_horn_length -max3002_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_max3002(type = "bottom", hole = "one");
        else servo_sleeve_max3002(type = "bottom_hole", hole = "two");
    }

    translate([-17.1*abs(servo_axis_clear-servo_H)+6, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-7.25/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}

module sleeve_hinge_max3002(screw){
    support_width_hinge = (max3002_total_length - max3002_length)/2 + 2;
    support_width_sleeve = (max3002_total_length - max3002_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = max3002_length + 0.9;
    servo_H = max3002_height + 0.5;
    support_z_sleeve = max3002_width + 0.25;
    servo_axis_clear = (max3002_horn_length -max3002_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+6 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-14, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_max3002();
    
  servo_sleeve_max3002(type = "side_hole", hole = "one");
     }
  }
  
}

module s8330m_final(){
    motor_s8330m();
    translate([0,-30,12]) rotate([90,0,-90]) 
        color("white") sleeve_hinge_s8330m("two");
    translate([0,18,31]) rotate([0,-90,0]) 
        color("white")servo_hinge_s8330m();
    translate([0,1,-120]) rotate([90,0,0]) 
        motor_s8330m();
    translate([0,-57.5,-90]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_s8330m();
}

module mg946r_final(){
    motor_mg946r();
    //rotate([0,0,180*$t-90]) 
    translate([-1,-39,110]) rotate([90,0,-90])
         color("white") hinge_sleeve_alt_hinge_mg946r();
    translate([0,-38.25+17.5,9-199.5+199.5]) rotate([90,0,-90])
         color("white") sleeve_hinge_mg946r("two");
    translate([0,-74.5,-79.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_mg946r();
    translate([0,4,-100.25]) rotate([90,0,0])
        motor_mg946r();
}

module hk15328_final(){
    motor_hk15328();
    translate([0,-64-2.45,90.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_hk15328();
    translate([0,-21,8]) rotate([90,0,-90])
         color("white") sleeve_hinge_hk15328("two");
    translate([0,-66.5,-70.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_hk15328();
    translate([0,3.5,-91.5]) rotate([90,0,0])
        motor_hk15328();
}

module hd1160a_final(){
    motor_hd1160a();
    translate([0,-11,64.75]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_hd1160a();
    translate([0,-14.5,5]) rotate([90,0,-90])
         color("white") sleeve_hinge_hd1160a("two");
    translate([0,-130.5,-67.25]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_hd1160a();
    translate([0,6.5,-81.5]) rotate([90,0,0])
        motor_hd1160a();
}

module tss10mg_final(){
   motor_tss10mg();
    translate([0,-131.5,84]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_tss10mg();
    translate([0,-12,5]) rotate([90,0,-90])
         color("white") sleeve_hinge_tss10mg("two");
    translate([0,-77.5,-55.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_tss10mg();
    translate([0,5.25,-67.5]) rotate([90,0,0])
        motor_tss10mg();
}

module max3002_final(){
    motor_max3002();
    translate([0,-12,61.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_max3002();
    translate([0,-12,5.5]) rotate([90,0,-90])
         color("white") sleeve_hinge_max3002("two");
    translate([0,-84.5,-55]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_max3002();
    translate([0,6,-67]) rotate([90,0,0])
        motor_max3002();
}

module servo_render(){
    s8330m_final(); //HT
//    translate([0,-9.5,-199.5]) rotate([0,0,0])
    translate([0,0,-199.5])
        mg946r_final(); //MT1 
//    translate([0,-26.5,-375.3]) rotate([0,0,0])
   translate([0,0,-369.75])
        hk15328_final(); //MT2 
//    translate([0,-37,-532]) rotate([0,0,0])
    translate([0,0,-526.5])
        hd1160a_final(); //LT1 
//    translate([0,-41,-673]) rotate([0,0,0])
    translate([0,0,-662.75])
        tss10mg_final(); //LT2
//    translate([0,-47,-792.5])
    translate([0,0,-781.5])
        max3002_final(); //LT3
    
    
    translate([-17,23.3,-162.65]) rotate([90,0,90])
        color("blue") plate_2();
// ---------- special package ------------ //
    //mg995_final();
    //xgd11hmb_final();
    //tgy1501_final();
}

servo_render();
