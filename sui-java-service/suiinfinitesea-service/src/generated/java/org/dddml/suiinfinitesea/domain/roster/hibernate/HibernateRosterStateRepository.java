// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.roster.hibernate;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.dddml.suiinfinitesea.domain.roster.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateRosterStateRepository implements RosterStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("RosterId", "Status", "Speed", "ShipIds", "Ships", "UpdatedCoordinates", "CoordinatesUpdatedAt", "TargetCoordinates", "OriginCoordinates", "SailDuration", "SetSailAt", "ShipBattleId", "EnvironmentOwned", "BaseExperience", "EnergyVault", "Version", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted", "RosterShipsItems"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public RosterState get(RosterId id, boolean nullAllowed) {
        RosterState.SqlRosterState state = (RosterState.SqlRosterState)getCurrentSession().get(AbstractRosterState.SimpleRosterState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractRosterState.SimpleRosterState();
            state.setRosterId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (RosterState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{RosterState.SqlRosterState.class, Saveable.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(RosterState state) {
        RosterState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (RosterState) getReadOnlyProxyGenerator().getTarget(state);
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

    public void merge(RosterState detached) {
        RosterState persistent = getCurrentSession().get(AbstractRosterState.SimpleRosterState.class, detached.getRosterId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(RosterState persistent, RosterState detached) {
        ((AbstractRosterState) persistent).merge(detached);
    }

}

