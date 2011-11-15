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

package com.flyingtophat.basicbot
{
	import com.flyingtophat.geometry.Circle;
	import flash.display.Sprite;
	
	public interface IBot
	{
		/**
		 * Represents the bot's body
		 */
        function get body():Circle;

        /**
		 * Called when another bot enters this bot's proximity.
		 * Allowing for them to influence eachother.
		 *
		 * It is within this stage that the bot's state should
		 * be changed, ready for the wake() method to be called.
		 */
		function communicate(bot:IBot):void;

		/**
		 * Wakes the bot up inorder to allow it to act/react
		 * to any bots that communicated with it.
		 */
		function wake():void;

		/**
		 * Tells the bot that it's about to die.
		 * A good time to remove any strongly referenced event listeners etc.
		 */
		function die():void;

        /**
		 * Tests for a collision between two bots
		 */
		function hitTest(bot:IBot):Boolean;

		function get x():Number;
		function set x(position:Number):void;
		function get y():Number;
		function set y(position:Number):void;
	}
	
}