// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.roster;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;

public class RosterCommands {
    private RosterCommands() {
    }

    public static class Create extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "Create";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
        }

        /**
         * Status
         */
        private Integer status;

        public Integer getStatus() {
            return this.status;
        }

        public void setStatus(Integer status) {
            this.status = status;
        }

        /**
         * Speed
         */
        private Long speed;

        public Long getSpeed() {
            return this.speed;
        }

        public void setSpeed(Long speed) {
            this.speed = speed;
        }

        /**
         * Updated Coordinates
         */
        private Coordinates updatedCoordinates;

        public Coordinates getUpdatedCoordinates() {
            return this.updatedCoordinates;
        }

        public void setUpdatedCoordinates(Coordinates updatedCoordinates) {
            this.updatedCoordinates = updatedCoordinates;
        }

        /**
         * Coordinates Updated At
         */
        private BigInteger coordinatesUpdatedAt;

        public BigInteger getCoordinatesUpdatedAt() {
            return this.coordinatesUpdatedAt;
        }

        public void setCoordinatesUpdatedAt(BigInteger coordinatesUpdatedAt) {
            this.coordinatesUpdatedAt = coordinatesUpdatedAt;
        }

        /**
         * Target Coordinates
         */
        private Coordinates targetCoordinates;

        public Coordinates getTargetCoordinates() {
            return this.targetCoordinates;
        }

        public void setTargetCoordinates(Coordinates targetCoordinates) {
            this.targetCoordinates = targetCoordinates;
        }

        /**
         * Origin Coordinates
         */
        private Coordinates originCoordinates;

        public Coordinates getOriginCoordinates() {
            return this.originCoordinates;
        }

        public void setOriginCoordinates(Coordinates originCoordinates) {
            this.originCoordinates = originCoordinates;
        }

        /**
         * Ship Battle Id
         */
        private String shipBattleId;

        public String getShipBattleId() {
            return this.shipBattleId;
        }

        public void setShipBattleId(String shipBattleId) {
            this.shipBattleId = shipBattleId;
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

    public static class CreateEnvironmentRoster extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "CreateEnvironmentRoster";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Ship Resource Quantity
         */
        private Long shipResourceQuantity;

        public Long getShipResourceQuantity() {
            return this.shipResourceQuantity;
        }

        public void setShipResourceQuantity(Long shipResourceQuantity) {
            this.shipResourceQuantity = shipResourceQuantity;
        }

        /**
         * Ship Base Resource Quantity
         */
        private Long shipBaseResourceQuantity;

        public Long getShipBaseResourceQuantity() {
            return this.shipBaseResourceQuantity;
        }

        public void setShipBaseResourceQuantity(Long shipBaseResourceQuantity) {
            this.shipBaseResourceQuantity = shipBaseResourceQuantity;
        }

        /**
         * Base Experience
         */
        private Long baseExperience;

        public Long getBaseExperience() {
            return this.baseExperience;
        }

        public void setBaseExperience(Long baseExperience) {
            this.baseExperience = baseExperience;
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

    public static class AddShip extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "AddShip";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
        }

        /**
         * Ship
         */
        private String ship;

        public String getShip() {
            return this.ship;
        }

        public void setShip(String ship) {
            this.ship = ship;
        }

        /**
         * Position
         */
        private BigInteger position;

        public BigInteger getPosition() {
            return this.position;
        }

        public void setPosition(BigInteger position) {
            this.position = position;
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

    public static class SetSail extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "SetSail";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Target Coordinates
         */
        private Coordinates targetCoordinates;

        public Coordinates getTargetCoordinates() {
            return this.targetCoordinates;
        }

        public void setTargetCoordinates(Coordinates targetCoordinates) {
            this.targetCoordinates = targetCoordinates;
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
         * Sail Duration
         */
        private BigInteger sailDuration;

        public BigInteger getSailDuration() {
            return this.sailDuration;
        }

        public void setSailDuration(BigInteger sailDuration) {
            this.sailDuration = sailDuration;
        }

        /**
         * Updated Coordinates
         */
        private Coordinates updatedCoordinates;

        public Coordinates getUpdatedCoordinates() {
            return this.updatedCoordinates;
        }

        public void setUpdatedCoordinates(Coordinates updatedCoordinates) {
            this.updatedCoordinates = updatedCoordinates;
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

    public static class AdjustShipsPosition extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "AdjustShipsPosition";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Positions
         */
        private BigInteger[] positions;

        public BigInteger[] getPositions() {
            return this.positions;
        }

        public void setPositions(BigInteger[] positions) {
            this.positions = positions;
        }

        /**
         * Ship Ids
         */
        private String[] shipIds;

        public String[] getShipIds() {
            return this.shipIds;
        }

        public void setShipIds(String[] shipIds) {
            this.shipIds = shipIds;
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

    public static class TransferShip extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "TransferShip";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Ship Id
         */
        private String shipId;

        public String getShipId() {
            return this.shipId;
        }

        public void setShipId(String shipId) {
            this.shipId = shipId;
        }

        /**
         * To Roster
         */
        private RosterId toRoster;

        public RosterId getToRoster() {
            return this.toRoster;
        }

        public void setToRoster(RosterId toRoster) {
            this.toRoster = toRoster;
        }

        /**
         * To Position
         */
        private BigInteger toPosition;

        public BigInteger getToPosition() {
            return this.toPosition;
        }

        public void setToPosition(BigInteger toPosition) {
            this.toPosition = toPosition;
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

    public static class TransferShipInventory extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "TransferShipInventory";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * From Ship Id
         */
        private String fromShipId;

        public String getFromShipId() {
            return this.fromShipId;
        }

        public void setFromShipId(String fromShipId) {
            this.fromShipId = fromShipId;
        }

        /**
         * To Ship Id
         */
        private String toShipId;

        public String getToShipId() {
            return this.toShipId;
        }

        public void setToShipId(String toShipId) {
            this.toShipId = toShipId;
        }

        /**
         * Item Id Quantity Pairs
         */
        private ItemIdQuantityPairs itemIdQuantityPairs;

        public ItemIdQuantityPairs getItemIdQuantityPairs() {
            return this.itemIdQuantityPairs;
        }

        public void setItemIdQuantityPairs(ItemIdQuantityPairs itemIdQuantityPairs) {
            this.itemIdQuantityPairs = itemIdQuantityPairs;
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

    public static class TakeOutShipInventory extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "TakeOutShipInventory";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Ship Id
         */
        private String shipId;

        public String getShipId() {
            return this.shipId;
        }

        public void setShipId(String shipId) {
            this.shipId = shipId;
        }

        /**
         * Item Id Quantity Pairs
         */
        private ItemIdQuantityPairs itemIdQuantityPairs;

        public ItemIdQuantityPairs getItemIdQuantityPairs() {
            return this.itemIdQuantityPairs;
        }

        public void setItemIdQuantityPairs(ItemIdQuantityPairs itemIdQuantityPairs) {
            this.itemIdQuantityPairs = itemIdQuantityPairs;
        }

        /**
         * Updated Coordinates
         */
        private Coordinates updatedCoordinates;

        public Coordinates getUpdatedCoordinates() {
            return this.updatedCoordinates;
        }

        public void setUpdatedCoordinates(Coordinates updatedCoordinates) {
            this.updatedCoordinates = updatedCoordinates;
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

    public static class PutInShipInventory extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "PutInShipInventory";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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
         * Ship Id
         */
        private String shipId;

        public String getShipId() {
            return this.shipId;
        }

        public void setShipId(String shipId) {
            this.shipId = shipId;
        }

        /**
         * Item Id Quantity Pairs
         */
        private ItemIdQuantityPairs itemIdQuantityPairs;

        public ItemIdQuantityPairs getItemIdQuantityPairs() {
            return this.itemIdQuantityPairs;
        }

        public void setItemIdQuantityPairs(ItemIdQuantityPairs itemIdQuantityPairs) {
            this.itemIdQuantityPairs = itemIdQuantityPairs;
        }

        /**
         * Updated Coordinates
         */
        private Coordinates updatedCoordinates;

        public Coordinates getUpdatedCoordinates() {
            return this.updatedCoordinates;
        }

        public void setUpdatedCoordinates(Coordinates updatedCoordinates) {
            this.updatedCoordinates = updatedCoordinates;
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

    public static class Delete extends AbstractRosterCommand implements RosterCommand {

        public String getCommandType() {
            return "Delete";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Roster Id
         */
        private RosterId rosterId;

        public RosterId getRosterId() {
            return this.rosterId;
        }

        public void setRosterId(RosterId rosterId) {
            this.rosterId = rosterId;
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

