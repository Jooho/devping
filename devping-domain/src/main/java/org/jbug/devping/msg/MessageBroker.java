package org.jbug.devping.msg;

import org.jbug.devping.store.MessageStore;
import org.jbug.devping.utils.NumberUtil;
import org.jbug.devping.vo.UserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by jhouse on 10/3/14.
 */
@Component
public class MessageBroker {

    @Autowired
    MessageStore messageStore;

    public String generateChannelId(UserVo userVo) {

        StringBuilder channelIdBuilder = new StringBuilder();
        channelIdBuilder.append(userVo.getName());
        channelIdBuilder.append("_");
        channelIdBuilder.append(NumberUtil.randomInteger(0, 10000000));

        String channelId = channelIdBuilder.toString();
        messageStore.checkIdIsUnique(channelId, userVo);

        return null;

    }

}