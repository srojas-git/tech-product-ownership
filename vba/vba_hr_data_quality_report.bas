Sub GenerateDataQualityReport()' This macro generates a Data Quality Report evaluating completeness

    Dim wsData As Worksheet
    Dim wsReport As Worksheet
    Dim lastRow As Long
    Dim i As Integer
    Dim nullCount As Long
    Dim totalRows As Long
    Dim col As Integer
    Dim reportRow As Integer

    '1.Define the source data sheet (CHANGE "HR_Raw_Dirty")Set wsData= ThisWorkbook.Sheets("HR_Raw_Dirty")' 2. Create or clear the Report sheet
    On Error Resume Next
    Set wsReport = ThisWorkbook.Sheets("Data_Quality_Report")
    On Error GoTo 0

    If wsReport Is Nothing Then
        Set wsReport = ThisWorkbook.Sheets.Add(After:=wsData)
        wsReport.Name = "Data_Quality_Report"
    Else
        wsReport.Cells.Clear
    End If

    '3. Format the Report HeadersWith wsReport
        .Range("A1").Value= "DATA QUALITY REPORT - HR ANALYTICS"
        .Range("A1").Font.Bold=True
        .Range("A1").Font.Size=14
        .Range("A2").Value= "Generated on: "& Now()

        .Range("A4").Value= "Column Name"
        .Range("B4").Value= "Total Rows"
        .Range("C4").Value= "Missing/Null Values"
        .Range("D4").Value= "% Completeness"
        .Range("A4:D4").Font.Bold=True
        .Range("A4:D4").Interior.Color= RGB(68,114,196)' Blue header
        .Range("A4:D4").Font.Color = RGB(255, 255, 255) ' White textEndWith' 4. Calculate total rows in the data sheet
    lastRow = wsData.Cells(Rows.Count, 1).End(xlUp).Row
    totalRows = lastRow - 1 ' Exclude headerrow

    reportRow=5' Start writing results from row 5

    '5. Loop througheachcolumnto count missingvaluesFor col=1To wsData.Cells(1, Columns.Count).End(xlToLeft).Column
        nullCount=0' Loop through each row in the current column
        For i = 2 To lastRow
            If IsEmpty(wsData.Cells(i, col)) Or wsData.Cells(i, col).Value = "" Then
                nullCount = nullCount + 1
            End If
        Next i

        ' Calculate completeness percentage
        Dim completitudAsDouble
        completitud= ((totalRows- nullCount)/ totalRows)*100' Write results to the report sheet
        wsReport.Cells(reportRow, 1).Value = wsData.Cells(1, col).Value
        wsReport.Cells(reportRow, 2).Value = totalRows
        wsReport.Cells(reportRow, 3).Value = nullCount
        wsReport.Cells(reportRow, 4).Value = Round(completitud, 2) & "%"

        ' Apply Conditional Formatting: Red if completeness<100%
        If completitud<100Then
            wsReport.Cells(reportRow,4).Interior.Color= RGB(255,199,206)' Light red
        End If

        reportRow = reportRow + 1
    Next col

    '6.Final Formatting
    wsReport.Columns("A:D").AutoFit

    MsgBox "Data Quality Report generated successfully in the 'Data_Quality_Report' tab.", vbInformationEnd Sub
