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
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    
    /**
     * Managers the interaction of a collection of bots.
     * Using this the BotManager to handle the bots ensures consistant behaviour
     * with future updates.
     *
     * @author <a href="http://flyingtophat.co.uk">Lucas</a>
     */
    public class BotManager
    {
        /* Total bots that can be created. Defined for system performance */
        public static const TOTAL_BOTS:uint = 40;
        
        /* Commonly used index holders used by for-loops in functions that are
         * designed to be called alot. Reducing costs of constant
         * instantiation within the methods */
        private var _indexOne:uint, _indexTwo:uint;
        
        /**
         * Boundry used for the wrapping of the bots
         * @default null
         */
        private var _boundary:Rectangle;
        
        /**
         * The collection of bots that are handled by the instance of the BotManager.
         * Collection is limited to the value defined in BotManager.TOTAL_BOTS
         */
        public const botCollection:Vector.<IBot> = new Vector.<IBot>(TOTAL_BOTS, true);
        
        /**
         * Create an instance of the BotManager to handle the motion and
         * interaction of many bots.
         *
         * The bots will automatically wrap around the boundary if provided.
         * @param    boundry    The boundry that the bots can wrap around
         */
        public function BotManager(boundry:Rectangle = null)
        {
            _boundary = boundry;
        }

        /**
         * Calls all the methods repsonsible for normal operation of the bots
         * (scanning proximities and waking).
         *
         * It is usually best to call this method instead of each of the methods
         * individually to ensure the correct methods and ordering is called in
         * future updates.
         */
        public function progressBots():void
        {
            proximityScan();
            wakeBots();
        }
        
        /**
         * Scans through all the bots and checks for encroachments into
         * eachothers proximities. In instances where a bot is within anothers
         * proximity then the other bot has its communication method called.
         */
        public function proximityScan():void
        {
            // Scan each bot
            for (_indexOne = 0; _indexOne < TOTAL_BOTS; _indexOne++ )
                if ( botCollection[_indexOne] != null)
                {
                    // Test for bots within its proximity then alert
                    // it to their presence
                    for (_indexTwo = 0; _indexTwo < TOTAL_BOTS; _indexTwo++ )
                        if ( (botCollection[_indexTwo] != null) &&
                             (botCollection[_indexTwo] != botCollection[_indexOne]))
                            if (botCollection[_indexOne].hitTest(botCollection[_indexTwo]))
                            {
                                botCollection[_indexOne].communicate(botCollection[_indexTwo]);
                            }
                }
        }
        
        /**
         * Wakes up each of the bots to act/react
         */
        public function wakeBots():void
        {
            for (_indexOne = 0; _indexOne < TOTAL_BOTS; _indexOne++)
                if ( botCollection[_indexOne] != null)
                {
                    botCollection[_indexOne].wake();
                    
                    // The wake method is the point at which a bot usually
                    // moves, so check if they need to wrap boundary
                    if (_boundary != null)
                        wrapBoundary(botCollection[_indexOne]);
                }
        }
        
        /**
         * Repositions the bot to wrap around the provided boundry
         * @param    bot    Bot that's repositioned if necessary
         */
        private function wrapBoundary(bot:IBot):void
        {
            /* Without the addition/subtration of 1 below the bot flickers when
             * it reaches the edge, as one call of this method moves it to one
             * side and another call then moved it back to the other side,
             * and so forth */
            if (bot.x >= _boundary.right) bot.x = _boundary.left + 1;
            else if (bot.x < _boundary.left) bot.x = _boundary.right - 1;
            
            if (bot.y >= _boundary.bottom) bot.y = _boundary.top + 1;
            else if (bot.y < _boundary.top) bot.y = _boundary.bottom - 1;
        }
        
    }

}