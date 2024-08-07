// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatarchange.hibernate;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.dddml.suiinfinitesea.domain.avatarchange.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateAvatarChangeStateRepository implements AvatarChangeStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("AvatarId", "ImageUrl", "BackgroundColor", "Haircut", "Outfit", "Accessories", "Aura", "Symbols", "Effects", "Backgrounds", "Decorations", "Badges", "Version", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public AvatarChangeState get(String id, boolean nullAllowed) {
        AvatarChangeState.SqlAvatarChangeState state = (AvatarChangeState.SqlAvatarChangeState)getCurrentSession().get(AbstractAvatarChangeState.SimpleAvatarChangeState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractAvatarChangeState.SimpleAvatarChangeState();
            state.setAvatarId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (AvatarChangeState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{AvatarChangeState.SqlAvatarChangeState.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(AvatarChangeState state) {
        AvatarChangeState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (AvatarChangeState) getReadOnlyProxyGenerator().getTarget(state);
        }
        if(s.getOffChainVersion() == null) {
            getCurrentSession().save(s);
        } else {
            getCurrentSession().update(s);
        }

        if (s instanceof Saveable)
        {
            Saveable saveable = (Saveable) s;
            saveable.save();
        }
        getCurrentSession().flush();
    }

    public void merge(AvatarChangeState detached) {
        AvatarChangeState persistent = getCurrentSession().get(AbstractAvatarChangeState.SimpleAvatarChangeState.class, detached.getAvatarId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(AvatarChangeState persistent, AvatarChangeState detached) {
        ((AbstractAvatarChangeState) persistent).merge(detached);
    }

}

