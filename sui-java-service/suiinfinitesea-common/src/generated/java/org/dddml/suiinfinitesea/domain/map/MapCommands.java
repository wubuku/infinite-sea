// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.map;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;

public class MapCommands {
    private MapCommands() {
    }

    public static class __Init__ extends AbstractMapCommand implements MapCommand {

        public String getCommandType() {
            return "__Init__";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class AddIsland extends AbstractMapCommand implements MapCommand {

        public String getCommandType() {
            return "AddIsland";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Coordinates
         */
        private Coordinates coordinates;

        public Coordinates getCoordinates() {
            return this.coordinates;
        }

        public void setCoordinates(Coordinates coordinates) {
            this.coordinates = coordinates;
        }

        /**
         * Resources
         */
        private ItemIdQuantityPairs resources;

        public ItemIdQuantityPairs getResources() {
            return this.resources;
        }

        public void setResources(ItemIdQuantityPairs resources) {
            this.resources = resources;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class ClaimIsland extends AbstractMapCommand implements MapCommand {

        public String getCommandType() {
            return "ClaimIsland";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Coordinates
         */
        private Coordinates coordinates;

        public Coordinates getCoordinates() {
            return this.coordinates;
        }

        public void setCoordinates(Coordinates coordinates) {
            this.coordinates = coordinates;
        }

        /**
         * Claimed By
         */
        private String claimedBy;

        public String getClaimedBy() {
            return this.claimedBy;
        }

        public void setClaimedBy(String claimedBy) {
            this.claimedBy = claimedBy;
        }

        /**
         * Claimed At
         */
        private BigInteger claimedAt;

        public BigInteger getClaimedAt() {
            return this.claimedAt;
        }

        public void setClaimedAt(BigInteger claimedAt) {
            this.claimedAt = claimedAt;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class GatherIslandResources extends AbstractMapCommand implements MapCommand {

        public String getCommandType() {
            return "GatherIslandResources";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Player
         */
        private String player;

        public String getPlayer() {
            return this.player;
        }

        public void setPlayer(String player) {
            this.player = player;
        }

        /**
         * Clock
         */
        private String clock;

        public String getClock() {
            return this.clock;
        }

        public void setClock(String clock) {
            this.clock = clock;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

}

