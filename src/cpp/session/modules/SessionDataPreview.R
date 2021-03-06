#
# SessionDataPreview.R
#
# Copyright (C) 2009-18 by RStudio, Inc.
#
# Unless you have received this program directly from RStudio pursuant
# to the terms of a commercial license agreement with RStudio, then
# this program is licensed to you under the terms of version 3 of the
# GNU Affero General Public License. This program is distributed WITHOUT
# ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
# AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
#
#

.rs.addFunction("previewDataFrame", function(data, script)
{
   preparedData <- .rs.prepareViewerData(
      data,
      maxFactors = 100,
      maxCols = 100,
      maxRows = 100
   )

   preview <- list(
      data = preparedData$data,
      columns = preparedData$columns,
      title = if (is.character(script)) .rs.scalar(script) else NULL
   )

   .rs.enqueClientEvent("data_output_completed", preview)
})

.rs.addFunction("previewSql", function(conn, statement, ...)
{
   script <- NULL
   if (file.exists(statement)) {
      script <- statement
      statement <- paste(readLines(script), collapse = "\n")
   }

   data <- DBI::dbGetQuery(conn, statement = statement, ...)

   .rs.previewDataFrame(data, script)
})

.rs.addGlobalFunction("previewSql", function(conn, statement, ...)
{
   .rs.previewSql(conn, statement, ...)
})
