%% Runs all tests for Polyphase Decimator DSP

clear;
clc;

%% ==========================================
%% PROJECT ROOT
%% ==========================================

projectRoot = fileparts(mfilename("fullpath"));

%% ==========================================
%% PROJECT PATHS
%% ==========================================

addpath(genpath(fullfile(projectRoot, "Design")));

%% ==========================================
%% LOCATE TESTS
%% ==========================================

TestRoot = fullfile(projectRoot, "Tests");

if ~isfolder(TestRoot)
    error( ...
        'PolyphaseDSP:TestsNotFound', ...
        'The Polyphase DSP Tests folder could not be located.');
end

%% ==========================================
%% CREATE TEST SUITE
%% ==========================================

TestSuite = testsuite( ...
    TestRoot, ...
    "IncludeSubfolders", true);

%% ==========================================
%% CONFIGURE TEST RUNNER
%% ==========================================

Runner = matlab.unittest.TestRunner.withDefaultPlugins;

%% ==========================================
%% CI TEST REPORTING
%% ==========================================

if strcmpi(getenv("GITHUB_ACTIONS"), "true")

    ReportRoot = fullfile( ...
        projectRoot, ...
        "test-results");

    if ~isfolder(ReportRoot)
        mkdir(ReportRoot);
    end

    %% JUnit XML report
    import matlab.unittest.plugins.XMLPlugin

    XMLReport = fullfile( ...
        ReportRoot, ...
        "polyphase-dsp-test-results.xml");

    Runner.addPlugin( ...
        XMLPlugin.producingJUnitFormat(XMLReport));

    %% HTML report
    import matlab.unittest.plugins.TestReportPlugin

    HTMLReport = fullfile( ...
        ReportRoot, ...
        "polyphase-dsp-test-report.html");

    Runner.addPlugin( ...
        TestReportPlugin.producingHTML( ...
            HTMLReport, ...
            "Title", ...
            "Polyphase Decimator Verification Report"));
end

%% ==========================================
%% RUN TESTS
%% ==========================================

results = Runner.run(TestSuite);

disp(results);

%% ==========================================
%% VERIFY TEST RESULTS
%% ==========================================

assertSuccess(results);