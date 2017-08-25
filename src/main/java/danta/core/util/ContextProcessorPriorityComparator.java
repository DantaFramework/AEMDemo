/**
 * Danta Core Bundle
 * (danta.core)
 *
 * Copyright (C) 2017 Tikal Technologies, Inc. All rights reserved.
 *
 * Licensed under GNU Affero General Public License, Version v3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.gnu.org/licenses/agpl-3.0.txt
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied;
 * without even the implied warranty of MERCHANTABILITY.
 * See the License for more details.
 */

package danta.core.util;

import danta.api.ContextProcessor;
import java.util.Comparator;

/**
 * This class is used to sort a list of HandlebarsContextProcessors. The list
 * is ordered in descending order based on the priority.
 * <p/>
 * Note that this class is not intended to be used to order a sorted collection,
 * such as TreeSet.
 */
public class ContextProcessorPriorityComparator
        implements Comparator<ContextProcessor> {
    @Override
    public int compare(ContextProcessor cp1, ContextProcessor cp2) {
        return Integer.compare(cp2.priority(), cp1.priority());
    }
}
