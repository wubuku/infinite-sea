// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.bean.*;
import com.github.wubuku.sui.utils.*;
import org.dddml.suiinfinitesea.domain.player.*;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.sui.contract.DomainBeanUtils;
import org.dddml.suiinfinitesea.sui.contract.Player;
import org.dddml.suiinfinitesea.sui.contract.PlayerItem;
import org.dddml.suiinfinitesea.sui.contract.PlayerItemDynamicField;

import java.util.*;
import java.math.*;
import java.util.function.*;

public class SuiPlayerStateRetriever {

    private SuiJsonRpcClient suiJsonRpcClient;

    private Function<String, PlayerState.MutablePlayerState> playerStateFactory;
    private BiFunction<PlayerState, Long, PlayerItemState.MutablePlayerItemState> playerItemStateFactory;

    public SuiPlayerStateRetriever(SuiJsonRpcClient suiJsonRpcClient,
                                  Function<String, PlayerState.MutablePlayerState> playerStateFactory,
                                  BiFunction<PlayerState, Long, PlayerItemState.MutablePlayerItemState> playerItemStateFactory
    ) {
        this.suiJsonRpcClient = suiJsonRpcClient;
        this.playerStateFactory = playerStateFactory;
        this.playerItemStateFactory = playerItemStateFactory;
    }

    public PlayerState retrievePlayerState(String objectId) {
        SuiMoveObjectResponse<Player> getObjectDataResponse = suiJsonRpcClient.getMoveObject(
                objectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), Player.class
        );
        if (getObjectDataResponse.getData() == null) {
            return null;
        }
        Player player = getObjectDataResponse.getData().getContent().getFields();
        return toPlayerState(player);
    }

    private PlayerState toPlayerState(Player player) {
        PlayerState.MutablePlayerState playerState = playerStateFactory.apply(player.getId().getId());
        playerState.setVersion(player.getVersion());
        playerState.setOwner(player.getOwner());
        playerState.setLevel(player.getLevel());
        playerState.setExperience(player.getExperience());
        if (player.getItems() != null) {
            String playerItemTableId = player.getItems().getFields().getId().getId();
            List<PlayerItem> items = getPlayerItems(playerItemTableId);
            for (PlayerItem i : items) {
                ((EntityStateCollection.ModifiableEntityStateCollection)playerState.getItems()).add(toPlayerItemState(playerState, i));
            }
        }

        return playerState;
    }

    private PlayerItemState toPlayerItemState(PlayerState playerState, PlayerItem playerItem) {
        PlayerItemState.MutablePlayerItemState playerItemState = playerItemStateFactory.apply(playerState, playerItem.getItemId());
        playerItemState.setQuantity(playerItem.getQuantity());
        return playerItemState;
    }

    private List<PlayerItem> getPlayerItems(String playerItemTableId) {
        List<PlayerItem> playerItems = new ArrayList<>();
        String cursor = null;
        while (true) {
            DynamicFieldPage<?> playerItemFieldPage = suiJsonRpcClient.getDynamicFields(playerItemTableId, cursor, null);
            for (DynamicFieldInfo playerItemFieldInfo : playerItemFieldPage.getData()) {
                String fieldObjectId = playerItemFieldInfo.getObjectId();
                SuiMoveObjectResponse<PlayerItemDynamicField> getPlayerItemFieldResponse
                        = suiJsonRpcClient.getMoveObject(fieldObjectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), PlayerItemDynamicField.class);
                PlayerItem playerItem = getPlayerItemFieldResponse
                        .getData().getContent().getFields().getValue().getFields();
                playerItems.add(playerItem);
            }
            cursor = playerItemFieldPage.getNextCursor();
            if (!Page.hasNextPage(playerItemFieldPage)) {
                break;
            }
        }
        return playerItems;
    }

    
}

