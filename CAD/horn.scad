include <measures.scad>;

module horn_s8330m(){    
    linear_extrude(height = s8330m_horn_height, center = false)
    hull(){
        translate([s8330m_horn_length -s8330m_horn_1stcircle/2, 0, 0]) circle(d = s8330m_horn_1stcircle, $fn = 32);
        circle(d = s8330m_horn_2ndcircle, $fn = 32);
    }
}

module horn_mg946r(){
    
  linear_extrude(height = mg946r_horn_height, center = false)
      hull(){
       translate([mg946r_horn_length- mg946r_horn_1stcircle/2, 0, 0]) circle(d = mg946r_horn_1stcircle, $fn = 32);
       circle(d = mg946r_horn_2ndcircle, $fn = 32);
      }

}

module horn_single_hk15328(){
  linear_extrude(height = hk15328_horn_height, center = false)
      hull(){
       translate([hk15328_horn_length- hk15328_horn_1stcircle/2, 0, 0]) circle(d = hk15328_horn_1stcircle, $fn = 32);
       circle(d = 11, $fn = 32);
      }
}

module horn_hk15328(){
    for(i=[0:1])
    {
        rotate([0, 0, 180*i])
        horn_single_hk15328();
    }
    linear_extrude(height = hk15328_horn_height, center = false) circle(d = hk15328_horn_2ndcircle, $fn = 32);
}

module horn_tss10mg_hinge(){
  linear_extrude(height = tss10mg_horn_height, center = false)
      hull(){
       translate([tss10mg_horn_length- tss10mg_horn_1stcircle/2+1, 0, 0]) circle(d = tss10mg_horn_1stcircle, $fn = 32);
       circle(d = tss10mg_horn_2ndcircle, $fn = 32);
      }
}

module horn_tss10mg(){
  linear_extrude(height = tss10mg_horn_height-2, center = false)
      hull(){
       translate([tss10mg_horn_length- tss10mg_horn_1stcircle/2, 0, 0]) circle(d = tss10mg_horn_1stcircle, $fn = 32);
       circle(d = tss10mg_horn_2ndcircle, $fn = 32);
      }
}   

//horn_s8330m();
//translate([0,20,0]) 
//    horn_mg946r();
//translate([0,-20,0])
//    horn_hk15328();
//translate([20,0,0])
//    horn_tss10mg();