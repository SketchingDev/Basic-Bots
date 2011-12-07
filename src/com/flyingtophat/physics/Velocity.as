/*
 * Copyright (c) 2011 Lucas http://www.flyingtophat.co.uk
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

package com.flyingtophat.physics 
{
    
    /**
     * @author <a href="http://flyingtophat.co.uk">Lucas</a>
     */
    public class Velocity 
    {
        /** Radian value representing direction */
        public var direction:Number;
        public var speed:Number;
        
        /**
         * @param    direction Direction in radians
         */
        public function Velocity(direction:Number = 0, speed:Number = 0) 
        {
            this.direction = direction;
            this.speed = speed;
        }
        
        /**
         * Inverts the direction of the velocity
         */
        public function invertDirection():void
        {
            direction = direction + Math.PI;
            direction = direction % (Math.PI * 2);
        }
        
    }

}