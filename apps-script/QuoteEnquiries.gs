// ═══════════════════════════════════════════════════════════════
//  AF Credit — Quote Enquiry Handler
//  Google Apps Script Web App
//
//  SETUP:
//  1. Open your Google Sheet → Extensions → Apps Script
//  2. Replace everything with this code
//  3. Click Deploy → New deployment → Web app
//  4. Execute as: Me | Who has access: Anyone
//  5. Click Deploy, copy the Web App URL
//  6. Paste that URL into get-a-quote.html as APPS_SCRIPT_URL
// ═══════════════════════════════════════════════════════════════

var SHEET_NAME   = 'Enquiries';           // Tab name in your Google Sheet
var NOTIFY_EMAIL = 'enquiries@af.credit';

// Column headers — order must match the appendRow() call below
var HEADERS = [
  'Timestamp',
  'Borrower Name',
  'Email',
  'Mobile',
  'Borrower Type',
  'UK National?',
  'Main Residence Address',
  'Bad Credit History?',
  'Property Address',
  'Security Type',
  'Transaction Type',
  'Property Value (£)',
  'Purchase Price (£)',
  'Current Debt (£)',
  'Current Lender',
  'Rental Income (£/month)',
  'Net Loan Required (£)',
  'Purpose of Loan',
  'Exit Strategy',
  'Term Required (months)',
  'Desired Completion Date',
  'Refurb — GDV (£)',
  'Refurb — Type',
  'Refurb — Cost of Works (£)',
  '— INDICATIVE QUOTE —',
  'Gross Loan (£)',
  'Monthly Rate (%)',
  'LTV (%)',
  'Net Advance (£)',
  'Notes'
];

function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);
    var ss   = SpreadsheetApp.getActiveSpreadsheet();
    var sheet;

    // Create sheet/headers if first run
    try {
      sheet = ss.getSheetByName(SHEET_NAME);
      if (!sheet) {
        sheet = ss.insertSheet(SHEET_NAME);
      }
    } catch(err) {
      sheet = ss.getActiveSheet();
    }

    if (sheet.getLastRow() === 0) {
      sheet.appendRow(HEADERS);
      sheet.getRange(1, 1, 1, HEADERS.length).setFontWeight('bold');
      sheet.setFrozenRows(1);
    }

    // Append data row
    sheet.appendRow([
      new Date().toLocaleString('en-GB'),
      data.borrowerName    || '',
      data.email           || '',
      data.mobile          || '',
      data.borrowerType    || '',
      data.ukNational      || '',
      data.residenceAddress|| '',
      data.badCredit       || '',
      data.propertyAddress || '',
      data.securityType    || '',
      data.transaction     || '',
      data.propertyValue   || '',
      data.purchasePrice   || '',
      data.currentDebt     || '',
      data.currentLender   || '',
      data.rentalIncome    || '',
      data.netLoan         || '',
      data.purpose         || '',
      data.exitStrategy    || '',
      data.term            || '',
      data.completionDate  || '',
      data.gdv             || '',
      data.refurbType      || '',
      data.costOfWorks     || '',
      '',
      data.quoteGross      || '',
      data.quoteRate       || '',
      data.quoteLtv        || '',
      data.quoteNet        || '',
      data.notes           || ''
    ]);

    // Send email notification
    var subject = 'New bridging enquiry — ' + (data.borrowerName || 'Unknown') + ' — ' + (data.netLoan || '');

    var body = buildEmailBody(data);
    GmailApp.sendEmail(NOTIFY_EMAIL, subject, body, { name: 'AF Credit Enquiries' });

    return ContentService
      .createTextOutput(JSON.stringify({ success: true }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch(err) {
    return ContentService
      .createTextOutput(JSON.stringify({ success: false, error: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function buildEmailBody(d) {
  var lines = [
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    'NEW BRIDGING LOAN ENQUIRY — AF Credit',
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    '',
    '── BORROWER ─────────────────────────',
    'Name:              ' + (d.borrowerName     || '—'),
    'Email:             ' + (d.email            || '—'),
    'Mobile:            ' + (d.mobile           || '—'),
    'Borrower type:     ' + (d.borrowerType     || '—'),
    'UK national:       ' + (d.ukNational       || '—'),
    'Residence address: ' + (d.residenceAddress || '—'),
    'Bad credit:        ' + (d.badCredit        || '—'),
    '',
    '── PROPERTY ─────────────────────────',
    'Address:           ' + (d.propertyAddress  || '—'),
    'Security type:     ' + (d.securityType     || '—'),
    'Transaction:       ' + (d.transaction      || '—'),
    'Property value:    ' + (d.propertyValue    || '—'),
    'Purchase price:    ' + (d.purchasePrice    || '—'),
    'Current debt:      ' + (d.currentDebt      || '—'),
    'Current lender:    ' + (d.currentLender    || '—'),
    'Rental income:     ' + (d.rentalIncome     || '—'),
    '',
    '── LOAN ─────────────────────────────',
    'Net loan required: ' + (d.netLoan          || '—'),
    'Purpose:           ' + (d.purpose          || '—'),
    'Exit strategy:     ' + (d.exitStrategy     || '—'),
    'Term:              ' + (d.term             || '—') + ' months',
    'Completion date:   ' + (d.completionDate   || '—'),
  ];

  if (d.gdv || d.refurbType || d.costOfWorks) {
    lines = lines.concat([
      '',
      '── REFURBISHMENT ────────────────────',
      'GDV:               ' + (d.gdv            || '—'),
      'Refurb type:       ' + (d.refurbType     || '—'),
      'Cost of works:     ' + (d.costOfWorks    || '—'),
    ]);
  }

  lines = lines.concat([
    '',
    '── INDICATIVE QUOTE ─────────────────',
    'Gross loan:        ' + (d.quoteGross       || '—'),
    'Monthly rate:      ' + (d.quoteRate        || '—'),
    'LTV:               ' + (d.quoteLtv         || '—'),
    'Net advance:       ' + (d.quoteNet         || '—'),
  ]);

  if (d.notes) {
    lines = lines.concat(['', '── NOTES ────────────────────────────', d.notes]);
  }

  lines.push('');
  lines.push('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  return lines.join('\n');
}

// Allow GET for testing
function doGet(e) {
  return ContentService
    .createTextOutput('AF Credit enquiry handler is live.')
    .setMimeType(ContentService.MimeType.TEXT);
}
