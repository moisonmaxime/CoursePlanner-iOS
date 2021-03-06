//
//  TemsAndConditionsView.swift
//  Lynx
//
//  Created by Maxime Moison on 11/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit


class TermsAndConditionsView: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    init() {
        super.init(nibName: "TermsAndConditionsView", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = termsAndConditionsHTML.data(using: String.Encoding.unicode, allowLossyConversion: true),
            let str = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            textView.attributedText = str
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptTerms() {
        UserSettings.hasSignedTermsAndConditions = true
        self.dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate let termsAndConditionsHTML = """
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Privacy Policy</title>
<link rel="shortcut icon" type="image/png"
href="{% static "favicon.png" %}"/>

<!-- Required meta tags -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<body>
<div class="container">
<div class="jumbotron">
<h1 class="display-4">Privacy Policy</h1>
</div>

<p>Effective date: October 17, 2018</p>


<p>BobcatCourses Backend, BobcatCourses, Lynx, Lynx - Course Planner ("us", "we", or "our") operates the
https://cse120-course-planner.herokuapp.com website (the "Service").</p>

<p>This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use
our Service and the choices you have associated with that data. Our Privacy Policy for BobcatCourses Backend,
BobcatCourses, Lynx, Lynx - Course Planner is managed through <a
href="https://www.freeprivacypolicy.com/free-privacy-policy-generator.php">Free Privacy Policy</a>.</p>

<p>We use your data to provide and improve the Service. By using the Service, you agree to the collection and use of
information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this
Privacy Policy have the same meanings as in our Terms and Conditions, accessible from
https://cse120-course-planner.herokuapp.com</p>


<h2>Information Collection And Use</h2>

<p>We collect several different types of information for various purposes to provide and improve our Service to
you.</p>

<h3>Types of Data Collected</h3>

<h4>Personal Data</h4>

<p>While using our Service, we may ask you to provide us with certain personally identifiable information that can
be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is
not limited to:</p>

<ul>
<li>Email address</li>
<li>First name and last name</li>
<li>Cookies and Usage Data</li>
</ul>

<h4>Usage Data</h4>

<p>We may also collect information how the Service is accessed and used ("Usage Data"). This Usage Data may include
information such as your computer's Internet Protocol address (e.g. IP address), browser type, browser version,
the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique
device identifiers and other diagnostic data.</p>

<h4>Tracking & Cookies Data</h4>
<p>We use cookies and similar tracking technologies to track the activity on our Service and hold certain
information.</p>
<p>Cookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to
your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and
scripts to collect and track information and to improve and analyze our Service.</p>
<p>You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you
do not accept cookies, you may not be able to use some portions of our Service.</p>
<p>Examples of Cookies we use:</p>
<ul>
<li><strong>Session Cookies.</strong> We use Session Cookies to operate our Service.</li>
<li><strong>Preference Cookies.</strong> We use Preference Cookies to remember your preferences and various
settings.
</li>
<li><strong>Security Cookies.</strong> We use Security Cookies for security purposes.</li>
</ul>

<h2>Use of Data</h2>

<p>BobcatCourses Backend, BobcatCourses, Lynx, Lynx - Course Planner uses the collected data for various purposes:</p>
<ul>
<li>To provide and maintain the Service</li>
<li>To notify you about changes to our Service</li>
<li>To allow you to participate in interactive features of our Service when you choose to do so</li>
<li>To provide customer care and support</li>
<li>To provide analysis or valuable information so that we can improve the Service</li>
<li>To monitor the usage of the Service</li>
<li>To detect, prevent and address technical issues</li>
</ul>

<h2>Transfer Of Data</h2>
<p>Your information, including Personal Data, may be transferred to — and maintained on — computers located outside
of your state, province, country or other governmental jurisdiction where the data protection laws may differ
than those from your jurisdiction.</p>
<p>If you are located outside United States and choose to provide information to us, please note that we transfer
the data, including Personal Data, to United States and process it there.</p>
<p>Your consent to this Privacy Policy followed by your submission of such information represents your agreement to
that transfer.</p>
<p>BobcatCourses Backend, BobcatCourses, Lynx, Lynx - Course Planner will take all steps reasonably necessary to ensure that your data is
treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take
place to an organization or a country unless there are adequate controls in place including the security of your
data and other personal information.</p>

<h2>Disclosure Of Data</h2>

<h3>Legal Requirements</h3>
<p>BobcatCourses Backend, BobcatCourses, Lynx, Lynx - Course Planner may disclose your Personal Data in the good faith belief that such
action is necessary to:</p>
<ul>
<li>To comply with a legal obligation</li>
<li>To protect and defend the rights or property of BobcatCourses Backend, BobcatCourses, Lynx, Lynx - Course Planner</li>
<li>To prevent or investigate possible wrongdoing in connection with the Service</li>
<li>To protect the personal safety of users of the Service or the public</li>
<li>To protect against legal liability</li>
</ul>

<h2>Security Of Data</h2>
<p>The security of your data is important to us, but remember that no method of transmission over the Internet, or
method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect
your Personal Data, we cannot guarantee its absolute security.</p>

<h2>Service Providers</h2>
<p>We may employ third party companies and individuals to facilitate our Service ("Service Providers"), to provide
the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is
used.</p>
<p>These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated
not to disclose or use it for any other purpose.</p>

<h3>Analytics</h3>
<p>We may use third-party Service Providers to monitor and analyze the use of our Service.</p>
<ul>
<li>
<p><strong>Google Analytics</strong></p>
<p>Google Analytics is a web analytics service offered by Google that tracks and reports website traffic.
Google uses the data collected to track and monitor the use of our Service. This data is shared with
other Google services. Google may use the collected data to contextualize and personalize the ads of its
own advertising network.</p>
<p>You can opt-out of having made your activity on the Service available to Google Analytics by installing
the Google Analytics opt-out browser add-on. The add-on prevents the Google Analytics JavaScript (ga.js,
analytics.js, and dc.js) from sharing information with Google Analytics about visits activity.</p>
<p>For more information on the privacy practices of Google, please visit the Google Privacy & Terms web
page: <a href="https://policies.google.com/privacy?hl=en">https://policies.google.com/privacy?hl=en</a>
</p>
</li>
</ul>

<h2>Links To Other Sites</h2>
<p>Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you
will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site
you visit.</p>
<p>We have no control over and assume no responsibility for the content, privacy policies or practices of any third
party sites or services.</p>

<h2>Changes To This Privacy Policy</h2>
<p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy
Policy on this page.</p>
<p>We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective
and update the "effective date" at the top of this Privacy Policy.</p>
<p>You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are
effective when they are posted on this page.</p>


<h2>Contact Us</h2>
<p>If you have any questions about this Privacy Policy, please contact us:</p>
<ul>
<li>By visiting this page on our website: https://bobcatcourses.tk/about <a
href="https://bobcatcourses.tk/about">here</a></li>

</ul>


<div class="jumbotron">
<h1 class="display-4">Disclaimer</h1>
</div>

<p>Last updated: November 05, 2018</p>

<p>The information contained on https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com website and
Lynx, Lynx - Course Planner mobile app (the "Service") is for general information purposes only.</p>

<p>BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner assumes no responsibility for errors or omissions in the contents on the
Service.</p>

<p>In no event shall BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner be liable for any special, direct, indirect,
consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or
other tort, arising out of or in connection with the use of the Service or the contents of the Service.
BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner reserves the right to make additions, deletions, or modification to the
contents on the Service at any time without prior notice.</p>

<p>BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner does not warrant that the website is free of viruses or other harmful
components.</p>
<p>BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner does not grantee that any of the information provided is accurate.</p>

<h2>External links disclaimer</h2>

<p>https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com website and Lynx, Lynx - Course Planner
mobile app may contain links to external websites that are not provided or maintained by or in any way
affiliated with BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner</p>

<p>Please note that the BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner does not guarantee the accuracy, relevance, timeliness,
or completeness of any information on these external websites.</p>


<div class="jumbotron">
<h1 class="display-4">Terms and Conditions</h1>
</div>
<h2>Welcome to BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner</h2>
<p>These terms and conditions outline the rules and regulations for the use of BobcatCourses, BobcatCourses Backend,
Lynx, Lynx - Course Planner's Website.</p> <br/>
<span style="text-transform: capitalize;"> BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner</span>
<br/>
<p>By accessing this website we assume you accept these terms and conditions in full. Do not continue to use
BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner's website
if you do not accept all of the terms and conditions stated on this page.</p>
<p>The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice
and any or all Agreements: “Client”, “You” and “Your” refers to you, the person accessing this website
and accepting the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers
to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves, or either the Client
or ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake
the process of our assistance to the Client in the most appropriate manner, whether by formal meetings
of a fixed duration, or any other means, for the express purpose of meeting the Client’s needs in respect
of provision of the Company’s stated services/products, in accordance with and subject to, prevailing law
of . Any use of the above terminology or other words in the singular, plural,
capitalisation and/or he/she or they, are taken as interchangeable and therefore as referring to same.</p>
<h2>Cookies</h2>
<p>We employ the use of cookies. By using BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner's
website you consent to the use of cookies
in accordance with BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner’s privacy policy.</p>
<p>Most of the modern day interactive web sites
use cookies to enable us to retrieve user details for each visit. Cookies are used in some areas of our site
to enable the functionality of this area and ease of use for those people visiting. Some of our
affiliate / advertising partners may also use cookies.</p>
<h2>License</h2>
<p>Unless otherwise stated, BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner and/or it’s licensors
own the intellectual property rights for
all material on BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner. All intellectual property
rights are reserved. You may view and/or print
pages from https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com for your own personal use subject to restrictions set in these terms and
conditions.</p>
<p>You must not:</p>
<ol>
<li>Republish material from https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com</li>
<li>Sell, rent or sub-license material from https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com</li>
<li>Reproduce, duplicate or copy material from https://bobcatcourses.tk, https://cse120-course-planner.herokuapp.com</li>
</ol>
<p>Redistribute content from BobcatCourses, BobcatCourses Backend, Lynx, Lynx - Course Planner (unless content is
specifically made for redistribution).</p>
<h2>Iframes</h2>
<p>Without prior approval and express written permission, you may not create frames around our Web pages or
use other techniques that alter in any way the visual presentation or appearance of our Web site.</p>
<h2>Removal of links from our website</h2>
<p>If you find any link on our Web site or any linked web site objectionable for any reason, you may contact
us about this. We will consider requests to remove links but will have no obligation to do so or to respond
directly to you.</p>
<p>Whilst we endeavour to ensure that the information on this website is correct, we do not warrant its completeness
or accuracy; nor do we commit to ensuring that the website remains available or that the material on the
website is kept up to date.</p>
<h2>Content Liability</h2>
<p>We shall have no responsibility or liability for any content appearing on your Web site. You agree to indemnify
and defend us against all claims arising out of or based upon your Website. No link(s) may appear on any
page on your Web site or within any context containing content or materials that may be interpreted as
libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or
other violation of, any third party rights.</p>
<h2>Disclaimer</h2>
<p>To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions
relating to our website and the use of this website (including, without limitation, any warranties implied by
law in respect of satisfactory quality, fitness for purpose and/or the use of reasonable care and skill).
Nothing in this disclaimer will:</p>
<ol>
<li>limit or exclude our or your liability for death or personal injury resulting from negligence;</li>
<li>limit or exclude our or your liability for fraud or fraudulent misrepresentation;</li>
<li>limit any of our or your liabilities in any way that is not permitted under applicable law; or</li>
<li>exclude any of our or your liabilities that may not be excluded under applicable law.</li>
</ol>
<p>The limitations and exclusions of liability set out in this Section and elsewhere in this disclaimer: (a)
are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer or
in relation to the subject matter of this disclaimer, including liabilities arising in contract, in tort
(including negligence) and for breach of statutory duty.</p>
<p>To the extent that the website and the information and services on the website are provided free of charge,
we will not be liable for any loss or damage of any nature.</p>
<h2></h2>
<p></p>

</div>
</body>
</html>
"""
