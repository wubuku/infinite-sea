// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist.hibernate;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.dddml.suiinfinitesea.domain.whitelist.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateWhitelistStateRepository implements WhitelistStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("Id", "Paused", "Entries", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted", "Version"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public WhitelistState get(String id, boolean nullAllowed) {
        WhitelistState.SqlWhitelistState state = (WhitelistState.SqlWhitelistState)getCurrentSession().get(AbstractWhitelistState.SimpleWhitelistState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractWhitelistState.SimpleWhitelistState();
            state.setId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (WhitelistState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{WhitelistState.SqlWhitelistState.class, Saveable.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(WhitelistState state) {
        WhitelistState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (WhitelistState) getReadOnlyProxyGenerator().getTarget(state);
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

    public void merge(WhitelistState detached) {
        WhitelistState persistent = getCurrentSession().get(AbstractWhitelistState.SimpleWhitelistState.class, detached.getId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(WhitelistState persistent, WhitelistState detached) {
        ((AbstractWhitelistState) persistent).merge(detached);
    }

}

