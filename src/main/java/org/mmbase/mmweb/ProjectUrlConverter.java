/*

This file is part of the Open Images Platform, a webapplication to manage and publish open media.
    Copyright (C) 2009 Netherlands Institute for Sound and Vision

The Open Images Platform is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Open Images Platform is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with The Open Images Platform.  If not, see <http://www.gnu.org/licenses/>.

*/

package org.mmbase.mmweb;

import java.util.*;
import javax.servlet.http.HttpServletRequest;

import org.mmbase.bridge.Cloud;
import org.mmbase.bridge.Node;
import org.mmbase.framework.Block;
import org.mmbase.framework.Component;
import org.mmbase.framework.ComponentRepository;
import org.mmbase.framework.Framework;
import org.mmbase.framework.FrameworkException;
import org.mmbase.framework.basic.DirectoryUrlConverter;
import org.mmbase.framework.basic.BasicFramework;
import org.mmbase.framework.basic.Url;
import org.mmbase.framework.basic.BasicUrl;
import org.mmbase.mmsite.LocaleUtil;
import org.mmbase.util.transformers.Identifier;
import org.mmbase.util.functions.Parameter;
import org.mmbase.util.functions.Parameters;
import org.mmbase.util.logging.Logger;
import org.mmbase.util.logging.Logging;

/**
 * UrlConverter that can filter and create urls for projects.
 *
 * @author André van Toly
 * @version $Id: $
 */
public class ProjectUrlConverter extends DirectoryUrlConverter {
    private static final long serialVersionUID = 0L;
    private static final Logger log = Logging.getLoggerInstance(ProjectUrlConverter.class);

    private static Identifier trans = new Identifier();
    {
        trans.setWhitespaceReplacer("-");
    }
    private boolean useTitle = false;
    private final LocaleUtil  localeUtil = LocaleUtil.getInstance();

    public ProjectUrlConverter(BasicFramework fw) {
        super(fw);
        setDirectory("/projects/");
        Component mmweb = ComponentRepository.getInstance().getComponent("mmweb");
        if (mmweb == null) throw new IllegalStateException("No such component mmweb");
        addBlock(mmweb.getBlock("project"));
        addBlock(mmweb.getBlock("documentation"));
    }

    public void setUseTitle(boolean t) {
        useTitle = t;
    }

    @Override
    public int getDefaultWeight() {
        int q = super.getDefaultWeight();
        return Math.max(q, q + 1000);
    }

    public static final Parameter<Node> NODE = new Parameter<Node>("node", Node.class);

    @Override
    public Parameter[] getParameterDefinition() {
        return new Parameter[] {Parameter.REQUEST, Framework.COMPONENT, Framework.BLOCK, Parameter.CLOUD, NODE, LocaleUtil.LOCALE};
    }

    /**
     * Generates a nice urls for 'media'.
     */
    @Override
    protected void getNiceDirectoryUrl(StringBuilder b,
                                                 Block block,
                                                 Parameters parameters,
                                                 Parameters frameworkParameters,  boolean action) throws FrameworkException {
        if (log.isDebugEnabled()) {
            log.debug("" + parameters + frameworkParameters);
            log.debug("Found mmweb block " + block);
        }
        if (block.getName().equals("project")) {
            Node n = frameworkParameters.get(NODE);
            if (n == null) throw new IllegalStateException("No node parameter used in " + frameworkParameters);
            b.append(n.getNumber());
            if (useTitle) {
                b.append("/").append(transformTitle(n.getStringValue("title")));
            }
            localeUtil.appendLanguage(b, frameworkParameters);

            if (log.isDebugEnabled()) {
                log.debug("b now: " + b.toString());
            }
        } else if (block.getName().equals("documentation")) {
            Node n = frameworkParameters.get(NODE);
            if (n == null) throw new IllegalStateException("No node parameter used in " + frameworkParameters);
            b.append("documentation/").append(n.getNumber());
            if (useTitle) {
                b.append("/").append(transformTitle(n.getStringValue("title")));
            }
            localeUtil.appendLanguage(b, frameworkParameters);

            if (log.isDebugEnabled()) {
                log.debug("b now: " + b.toString());
            }

        }
    }


    /**
     * Translates the result of {@link #getNiceUrl} back to an actual JSP which can render the block
     */
    @Override
    public Url getFilteredInternalDirectoryUrl(List<String>  path, Map<String, ?> params, Parameters frameworkParameters) throws FrameworkException {
        if (log.isDebugEnabled()) log.debug("path pieces: " + path + ", path size: " + path.size());

        HttpServletRequest request = frameworkParameters.get(Parameter.REQUEST);

        StringBuilder result = new StringBuilder();
        if (path.size() == 0) {
            return Url.NOT; // handled by mmsite

        } else if ("documentation".equals(path.get(0))) {   // documentation/3456/title-of-doc
            result.append("/project.doc.jspx?n=");

            String last = path.get(path.size() - 1); // last element can contain language
            last = localeUtil.setLanguage(last, request);
            path.set(path.size() - 1, last);    // put it back

            String nr;
            if (path.size() > 1) {
                nr = path.get(1);    // nodenumber is second element after /documentation
            } else {
                if (log.isDebugEnabled()) log.debug("path not > 1");
                return Url.NOT;
            }

            Cloud cloud = frameworkParameters.get(Parameter.CLOUD);
            if (cloud.hasNode(nr) && cloud.mayRead(Integer.parseInt(nr))) {
                Node doc  = cloud.getNode(nr);

                String nmName = doc.getNodeManager().getName();
                if (!nmName.equals("documentation")) {
                    log.warn("not documentation #" + nr);
                    return Url.NOT;
                }

                frameworkParameters.set(NODE, doc);
                result.append(nr);

            } else {
                // node not found
                return Url.NOT;
            }

        } else {
            result.append("/project.jspx?n=");

            String last = path.get(path.size() - 1); // last element can contain language
            last = localeUtil.setLanguage(last, request);
            path.set(path.size() - 1, last);    // put it back

            String nr;
            if (path.size() > 0) {
                nr = path.get(0);    // nodenumber is first element
            } else {
                if (log.isDebugEnabled()) log.debug("path not > 0");
                return Url.NOT;
            }
            Cloud cloud = frameworkParameters.get(Parameter.CLOUD);
            if (cloud.hasNode(nr) && cloud.mayRead(Integer.parseInt(nr))) {
                Node project = cloud.getNode(nr);
                
                String nmName = project.getNodeManager().getName();
                if (!nmName.equals("project")) {
                    log.warn("not a project #" + nr);
                    return Url.NOT;
                }

                frameworkParameters.set(NODE, project);
                result.append(nr);

            } else {
                // node not found
                return Url.NOT;
            }

        }

        if (log.isDebugEnabled()) log.debug("returning: " + result.toString());
        return new BasicUrl(this, result.toString());
    }

    /*
    * Transform, replaces whitespace etc. with underscores, and beautify title.
    * @param title Title string to transform
    * @return transformed string
    */
    private static String transformTitle(String title) {
        String transformed = trans.transform(title);
        transformed = transformed.replaceAll("--", "-");
        if (transformed.startsWith("-")) transformed = transformed.substring(1, transformed.length());
        if (transformed.endsWith("-")) transformed = transformed.substring(0, transformed.length() - 1);
        return transformed;
    }

}
